# typst-dstu-nure

> [!NOTE]
> Цей скіл існує заради Typst-пакета
> [linerds/typst_nure_template](https://github.com/linerds/typst_nure_template/tree/0.1.1)
> і поза ним не має сенсу. Сам пакет — не моя робота: верстку за ДСТУ, титульні
> сторінки, стилі, нумерацію та бібліографію зробили його автори. Моє тут лише
> обгортка — опис правил оформлення, яких немає в документації пакета, та
> приклади використання. Якщо шукаєте власне інструмент, а не інструкцію для
> агента, вам потрібне першоджерело, а не цей репозиторій.

Агентний скіл для написання звітів з практичних, лабораторних і курсових робіт
ХНУРЕ у Typst із дотриманням ДСТУ.

Описує правила оформлення, яких недостатньо знати з самого пакета: безособовий
стиль викладу, пунктуацію списків, автонумерацію заголовків, оформлення
додатків і лістингів коду, плейсхолдери для ще не зроблених скріншотів.

## Встановлення

Скіл — це звичайна тека з `SKILL.md`, тому його розуміє будь-який агент із
підтримкою Agent Skills. Зручно тримати одну копію й розкласти симлінки:

```bash
git clone https://github.com/AyloRyd/typst-dstu-nure-skill.git ~/.skills/typst-dstu-nure-lb
```

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
ln -s ~/.skills/typst-dstu-nure-lb ~/.agents/skills/typst-dstu-nure

# Claude Code (Cursor і OpenCode теж читають цю теку)
ln -s ~/.skills/typst-dstu-nure-lb ~/.claude/skills/typst-dstu-nure

# Antigravity
ln -s ~/.skills/typst-dstu-nure-lb ~/.gemini/config/skills/typst-dstu-nure
```

Cursor додатково підхоплює теки Claude та Codex, а Codex у старіших версіях
шукав скіли в `$CODEX_HOME/skills` (типово `~/.codex/skills/`) — якщо у вас
саме така збірка, кладіть симлінк туди.

Скіли в теці проєкту зручні, коли робота здається з репозиторію: тоді
`SKILL.md` їде разом із нею й нічого не треба налаштовувати на іншій машині.

Сам Typst-пакет `nure` встановлюється окремо — див. `resources/README.md`.

## Структура

| Шлях | Призначення |
| --- | --- |
| `SKILL.md` | правила оформлення, головний файл скіла |
| `resources/README.md` | документація пакета `nure` (знімок з першоджерела) |
| `resources/lab.typ` | базовий шаблон лабораторної (знімок з першоджерела) |
| `resources/utils.typ` | утиліти пакета (знімок з першоджерела) |
| `examples/example-lb.typ` | приклад повного звіту з додатками |

Усі імена, групи та посилання в прикладах — вигадані заповнювачі.

## Першоджерело та ліцензія

Файли в `resources/` узято з Typst-пакета
[linerds/typst_nure_template](https://github.com/linerds/typst_nure_template/tree/0.1.1)
(дзеркало: [gitea.linerds.us](https://gitea.linerds.us/pencelheimer/typst_nure_template)),
який поширюється за GNU GPL v3. Це знімок, тому за свіжими деталями API
звертайтеся до першоджерела.

Копії навмисно зберігаються тут, а не замінені посиланням: якщо першоджерело
зникне, переїде або зміниться несумісно, скіл лишиться робочим. Зворотний бік —
знімок з часом відстає, тому перед тим, як покладатися на деталі API з
`resources/`, варто звірити їх з репозиторієм вище або з установленим пакетом
у `~/.local/share/typst/packages/local/nure/0.1.1/`.

Оскільки репозиторій містить ці файли, він також поширюється за
[GNU GPL v3](LICENSE).
