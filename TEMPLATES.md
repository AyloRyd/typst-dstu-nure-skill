# Шаблони пакета `nure`

Це довідник із підключення та використання самого пакета. Правила оформлення
тексту (стиль, списки, рисунки, додатки, код) описано в `SKILL.md`, вони
однакові для всіх шаблонів.

## Які шаблони є

Пакет `nure` існує у трьох несумісних між собою варіантах. Усі вони лежать у
`vendor/` як git-підмодулі:

| Шаблон | Версія | Імпорт | Документація |
| --- | --- | --- | --- |
| **beauloxe** (типовий) | 0.3.x | `@local/nure:0.3.0` | `vendor/beauloxe/README.md`, `vendor/beauloxe/docs/` |
| pencelheimer | 0.2.x | `@local/nure:0.2.0` | `vendor/pencelheimer/README.md`, doc-коментарі в `src/` |
| linerds | 0.1.x | `@local/nure:0.1.1` | `vendor/linerds/README.md`, doc-коментарі в `src/lib.typ` |

Користувача про шаблон НЕ питайте:

- завжди використовуйте **beauloxe**;
- pencelheimer чи linerds беріть лише тоді, коли користувач прямо назвав
  шаблон, його версію або характерну функцію (`config.setup`/`parts.*` —
  pencelheimer, `pz-lb` у версії 0.1.x — linerds);
- якщо редагується вже наявний звіт, лишайтеся на шаблоні, який він імпортує
  (`@local/nure:0.1.x` чи `0.2.x`), інакше звіт перестане компілюватися.

Справжню версію для імпорту беріть з поля `version` у
`vendor/<шаблон>/typst.toml`. Інформацію про API звіряйте з `vendor/`, а не з
пам'яті: шаблони відрізняються навіть назвами аргументів.

Еталонний повний звіт з додатками й лістингами є для кожного шаблону:
`examples/<шаблон>/example-pz.typ`. Тіло в них однакове, відрізняється лише
налаштування документа.

## Перед початком роботи

Підмодулі оновлює щотижнева GitHub Action
(`.github/workflows/update-vendor.yml`), тому самі нічого не тягніть з
першоджерел і нічого не пуште.

1. Перевірте, що підмодулі ініціалізовані:

   ```bash
   git -C <тека скіла> submodule status
   ```

   Якщо рядок починається з `-`, підмодуль порожній — ініціалізуйте:

   ```bash
   git -C <тека скіла> submodule update --init
   ```

2. Перевірте, що пакет потрібної версії встановлено для Typst:
   `~/.local/share/typst/packages/local/nure/<version>/` (на macOS —
   `~/Library/Application Support/typst/packages/local/nure/<version>/`). Якщо
   теки немає, підключіть клон симлінком і скажіть про це користувачеві:

   ```bash
   mkdir -p ~/.local/share/typst/packages/local/nure
   ln -s <тека скіла>/vendor/beauloxe ~/.local/share/typst/packages/local/nure/0.3.0
   ```

3. beauloxe потребує **Typst 0.15 або новішого** (`typst --version`). Якщо
   версія старіша, скажіть про це користувачеві — не перемикайтеся мовчки на
   інший шаблон.

## beauloxe (типовий)

Документація в `vendor/beauloxe/docs/`:

- `lab.md` — лабораторна чи практична від титулки до додатків;
- `coursework.md` — курсова робота й комплексний курсовий проєкт;
- `writing.md` — рисунки, таблиці, формули, код, посилання, джерела, додатки;
- `data.md` — усі поля `work(...)` / `doc.toml`, власні дисципліни;
- `reference.md` — перелік усіх функцій пакета.

Приклади в документації написано для mise з імпортом `@vendor/nure:0.3.0`.
Без mise (симлінк вище) імпортуйте `@local/nure:0.3.0`.

### Налаштування документа

Документ збирається з блоків. Дані роботи описуються один раз у `work(...)`, а
блоки беруть їх звідти:

```typst
#import "@local/nure:0.3.0": *

#let w = work(
  subject: "АПЗ", // скорочення, повна назва підставиться сама
  type: "ПЗ", // або "ЛБ", "КР", "РФ", "ІДЗ"
  number: 2,
  title: "Назва роботи",
  mentors: (
    (name: "Петренко П. П.", degree: "ст. викладач кафедри ПІ", gender: "m"), // m - чоловік, f - жінка
  ),
  authors: (
    (name: "Іваненко І. І.", edu-program: "ПЗПІ", group: "XX-X", gender: "m", variant: none),
  ),
)

#set document(..w.document)
#show: style.dstu.with(skip: 1) // титульна сторінка без номера

#report.title-page(w) // або report.title-page(w, layout: "complex")
#title-heading(w) // заголовок з темою; пропустіть, якщо не потрібен
#v(-style.spacing)
```

Якщо поруч зі звітом лежить `doc.toml` з тими самими полями, замість переліку
аргументів можна написати `work(..toml("doc.toml"), title: "...")`.

### Що є лише в beauloxe

- `fig(path("img/a.png"), [Підпис], label: <a>)` — рисунок з приміткою про
  джерело. Шлях обов'язково обгортайте в `path()`: рядок шукався б у теці
  пакета. Звичайний `#figure(image(...))` теж працює.
- `tab(caption: [...], columns: 2, header: (...), ...)` — таблиця за ДСТУ;
  будь-яка `figure(table(...))` теж переноситься з «Продовження таблиці».
- `bib` / `dstu-bibliography` — перелік джерел за ДСТУ 3008:2015 або 8302:2015
  з файлу `bibl.yml`.
- Курсові: `cw.*`, `cw-v2.*` або готові рецепти `coursework`, `coursework-v2`
  (див. `docs/coursework.md`).

## pencelheimer

Лише за прямим запитом. Підхід: `style.dstu` + глобальний `config.setup(...)`
+ блоки `parts.*`. Аргументи — у doc-коментарях `vendor/pencelheimer/src/config.typ`
і `src/parts.typ`, приклад — `examples/pencelheimer/example-pz.typ`.

## linerds

Лише за прямим запитом. Підхід: одна обгортка `#show: pz-lb.with(...)` (або
`coursework`, `coursework-v2`) з усіма аргументами. Сигнатури — у
`vendor/linerds/src/lib.typ`, приклад — `examples/linerds/example-pz.typ`.
Розділ README про Windows згадує функцію `nure-report` — такої в пакеті немає.
