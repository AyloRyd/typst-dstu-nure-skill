# typst-dstu-nure

Агентний скіл для написання звітів з практичних, лабораторних і курсових робіт
ХНУРЕ у Typst із дотриманням ДСТУ.

Описує правила оформлення, яких недостатньо знати з самого пакета: безособовий
стиль викладу, пунктуацію списків, автонумерацію заголовків, оформлення
додатків і лістингів коду, плейсхолдери для ще не зроблених скріншотів.

## Встановлення

Скіл сумісний з Claude Code та Antigravity. Достатньо покласти теку туди, де
відповідний агент шукає скіли, або зробити симлінк:

```bash
git clone https://github.com/AyloRyd/typst-dstu-nure-skill.git ~/.skills/typst-dstu-nure-lb

# Claude Code (назва теки має збігатися з полем name у SKILL.md)
ln -s ~/.skills/typst-dstu-nure-lb ~/.claude/skills/typst-dstu-nure

# Antigravity
ln -s ~/.skills/typst-dstu-nure-lb ~/.gemini/config/skills/typst-dstu-nure-lb
```

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

Оскільки репозиторій містить ці файли, він також поширюється за
[GNU GPL v3](LICENSE).
