#!/usr/bin/env bash
# Bump every submodule in vendor/ to its latest upstream commit and keep the
# bump only if the matching examples/<name>/*.typ still compile against it.
#
# Repos that publish versions as branches (linerds: 0.1.0, 0.1.1, ...) are
# switched to the highest such branch; the rest follow the branch already set
# in .gitmodules. Accepted bumps are staged, rejected ones are rolled back.
# Exits 1 if any bump was rejected, so a scheduled CI run shows up as failed.
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

pkgs=$(mktemp -d)
trap 'rm -rf "$pkgs"' EXIT

failed=()

link_package() {
  local dir=$1 name version
  name=$(sed -n 's/^name *= *"\(.*\)"/\1/p' "$dir/typst.toml" | head -1)
  version=$(sed -n 's/^version *= *"\(.*\)"/\1/p' "$dir/typst.toml" | head -1)
  mkdir -p "$pkgs/local/$name"
  ln -sfn "$root/$dir" "$pkgs/local/$name/$version"
}

for path in $(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' | awk '{print $2}'); do
  name=$(basename "$path")
  url=$(git config -f .gitmodules "submodule.$path.url")
  old_branch=$(git config -f .gitmodules "submodule.$path.branch" || echo main)
  old_commit=$(git rev-parse ":$path")

  newest=$(git ls-remote --heads "$url" \
    | sed -n 's#.*refs/heads/\([0-9]\+\.[0-9]\+\.[0-9]\+\)$#\1#p' \
    | sort -V | tail -1)
  branch=${newest:-$old_branch}
  [ "$branch" != "$old_branch" ] && git submodule set-branch -b "$branch" "$path"

  git submodule update --init --remote "$path"
  new_commit=$(git -C "$path" rev-parse HEAD)

  if [ "$new_commit" = "$old_commit" ] && [ "$branch" = "$old_branch" ]; then
    echo "$name: up to date ($branch @ ${old_commit:0:7})"
    continue
  fi

  echo "$name: $old_branch @ ${old_commit:0:7} -> $branch @ ${new_commit:0:7}"
  link_package "$path"

  ok=true
  for example in examples/"$name"/*.typ; do
    [ -e "$example" ] || continue
    if ! typst compile --package-path "$pkgs" "$example" "$pkgs/out.pdf"; then
      echo "$name: $example does not compile against the new version" >&2
      ok=false
    fi
  done

  if $ok; then
    git add .gitmodules "$path"
  else
    failed+=("$name")
    git submodule set-branch -b "$old_branch" "$path"
    git -C "$path" checkout -q "$old_commit"
  fi
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "Rejected bumps: ${failed[*]}. Update SKILL.md and examples/ by hand." >&2
  exit 1
fi
