# typst-dstu-nure

> [!NOTE]
> Цей скіл існує заради Typst-пакета `nure` у двох його варіантах —
> [pencelheimer/typst-nure-template](https://github.com/pencelheimer/typst-nure-template)
> (0.2.x, використовується типово) і
> [linerds/typst_nure_template](https://github.com/linerds/typst_nure_template)
> (0.1.x) — і поза ними не має сенсу. Сам пакет — не моя робота: верстку за ДСТУ, титульні
> сторінки, стилі, нумерацію та бібліографію зробили його автори. Моє тут лише
> обгортка — опис правил оформлення, яких немає в документації пакета, та
> приклади використання. Якщо шукаєте власне інструмент, а не інструкцію для
> агента, вам потрібні першоджерела, а не цей репозиторій.

Агентний скіл для написання звітів з практичних, лабораторних і курсових робіт
ХНУРЕ у Typst із дотриманням ДСТУ.

Описує правила оформлення, яких недостатньо знати з самого пакета: безособовий
стиль викладу, пунктуацію списків, автонумерацію заголовків, оформлення
додатків і лістингів коду, плейсхолдери для ще не зроблених скріншотів.

## Встановлення

Скіл — це звичайна тека з `SKILL.md`, тому його розуміє будь-який агент із
підтримкою Agent Skills. Зручно тримати одну копію й розкласти симлінки:

```bash
git clone --recursive https://github.com/AyloRyd/typst-dstu-nure-skill.git ~/.skills/typst-dstu-nure
```

`--recursive` потрібен, щоб одразу підтягнулися підмодулі з шаблонами. Якщо
клонували без нього — `git submodule update --init`. Оновлювати скіл разом із
шаблонами: `git pull --recurse-submodules`.

> [!IMPORTANT]
> Поле `name` в `SKILL.md` — `typst-dstu-nure`. Claude Code, Cursor і OpenCode
> вимагають, щоб ім'я теки збігалося з `name`, тому симлінк називайте саме
> `typst-dstu-nure`, а не так, як називається репозиторій.

Де який агент шукає скіли:

| Агент | Глобально | У межах проєкту |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex CLI | `~/.agents/skills/` | `.agents/skills/` (а також батьківські теки та корінь репозиторію) |
| Cursor | `~/.agents/skills/`, `~/.cursor/skills/` | `.agents/skills/`, `.cursor/skills/` |
| OpenCode | `~/.agents/skills/`, `~/.config/opencode/skills/`, `~/.claude/skills/` | `.agents/skills/`, `.opencode/skills/`, `.claude/skills/` |
| Antigravity | `~/.gemini/config/skills/` | — |

`~/.agents/skills/` читають Codex, Cursor і OpenCode, тому для всіх трьох
достатньо одного симлінка:

```bash
# Codex, Cursor, OpenCode
ln -s ~/.skills/typst-dstu-nure ~/.agents/skills/typst-dstu-nure

# Claude Code (Cursor і OpenCode теж читають цю теку)
ln -s ~/.skills/typst-dstu-nure ~/.claude/skills/typst-dstu-nure

# Antigravity
ln -s ~/.skills/typst-dstu-nure ~/.gemini/config/skills/typst-dstu-nure
```

Cursor додатково підхоплює теки Claude та Codex, а Codex у старіших версіях
шукав скіли в `$CODEX_HOME/skills` (типово `~/.codex/skills/`) — якщо у вас
саме така збірка, кладіть симлінк туди.

Скіли в теці проєкту зручні, коли робота здається з репозиторію: тоді
`SKILL.md` їде разом із нею й нічого не треба налаштовувати на іншій машині.

Сам Typst-пакет `nure` встановлюється окремо. Найпростіше — симлінком на
клон із цього репозиторію, тоді пакет оновлюватиметься разом зі скілом.
Ім'я теки має збігатися з `version` у `typst.toml` шаблону:

```bash
mkdir -p ~/.local/share/typst/packages/local/nure
ln -s ~/.skills/typst-dstu-nure/vendor/pencelheimer ~/.local/share/typst/packages/local/nure/0.2.0
ln -s ~/.skills/typst-dstu-nure/vendor/linerds ~/.local/share/typst/packages/local/nure/0.1.1
```

## Вибір шаблону

Агент не питає, який шаблон брати: типово це pencelheimer. linerds
використовується, лише якщо прямо про це попросити, або коли агент редагує
звіт, що вже імпортує `@local/nure:0.1.x`.

## Структура

| Шлях | Призначення |
| --- | --- |
| `SKILL.md` | правила оформлення, головний файл скіла |
| `vendor/pencelheimer/` | повний клон pencelheimer/typst-nure-template (підмодуль, гілка `main`) |
| `vendor/linerds/` | повний клон linerds/typst_nure_template (підмодуль, найновіша гілка-версія) |
| `examples/pencelheimer/example-pz.typ` | приклад повного звіту з додатками на pencelheimer |
| `examples/linerds/example-pz.typ` | той самий звіт на linerds |
| `scripts/update-vendor.sh` | оновлення підмодулів із перевіркою компіляції прикладів |
| `.github/workflows/update-vendor.yml` | щотижневий запуск цього скрипта |

Усі імена, групи та посилання в прикладах — вигадані заповнювачі.

## Оновлення шаблонів

Клони в `vendor/` навмисно лежать тут, а не замінені посиланням: агент може
досліджувати обидва шаблони повністю й без інтернету, а якщо першоджерело
зникне чи переїде, скіл лишиться робочим.

Щопонеділка GitHub Action запускає `scripts/update-vendor.sh`, який:

- підтягує останній коміт кожного підмодуля; для linerds, де версії живуть в
  окремих гілках (`0.1.0`, `0.1.1`, …), спершу перемикається на найновішу;
- компілює `examples/<шаблон>/*.typ` проти нової версії;
- комітить оновлення, лише якщо приклади зібралися, інакше відкочує його й
  завершує запуск з помилкою — GitHub надішле лист, а `SKILL.md` і приклади
  треба оновити вручну (зазвичай так буває, коли змінилася версія пакета чи
  його API).

Запустити позачергово можна вкладкою Actions → «Update vendored templates» →
Run workflow, або локально `scripts/update-vendor.sh` (потрібен `typst`).
Агенти під час роботи зі скілом нічого не тягнуть і не пушать — лише
перевіряють, що підмодулі ініціалізовані.

## Першоджерела та ліцензія

Обидва шаблони поширюються за GNU GPL v3. Оскільки цей репозиторій містить
їхні клони, він також поширюється за [GNU GPL v3](LICENSE).
