# Typst Template for NURE Works
<img src="assets/pz-lb_title_page.png" alt="pz-lb title page" width=350>

## General Info

This project contains template functions and some utilities for writing NURE works. All functions include documentation comments inside them, so you can explore all possibilities using LSP.

### Templates

#### `pz-lb` - For Practice and Laboratory Works
This template:
- Sets up document styles;
- Formats the title page according to NURE/DSTU guidelines.

#### `coursework` - For Course Works
This template:
- Sets up document styles;
- Formats the title, task, calendar plan, and abstract pages;
- Typesets the bibliography according to ДСТУ 3008:2015 using custom CSL style;
- Typesets the outline and appendices according to standard requirements.

#### `coursework-v2` - New Coursework Variant
This template keeps the legacy coursework template intact while offering the newer title/task-page layout. See `template/default/coursework-v2.typ` for an example entrypoint.

### Utilities
- `nheading` - For unnumbered headings, such as "Introduction" and "Conclusion".
- `hfill` - Fills horizontal space with a filled box instead of just empty space; useful for creating underlines.
- `uline` - Creates underlined fields that need to be filled, such as the name field on the task list.
- `bold` - Inserts bold text inside functional environments.
- `img` - Inserts images with a caption, automatically deriving the label from the image file name (use via `#import "@local/nure:0.1.1": utils` and call `utils.img`).

**Note:** `img()` is provided in `template/utils.typ` so you can copy it into your project root for compatibility, until [path() type](https://github.com/typst/typst/pull/7555) is released.

## Usage

### As a local typst package
You can install the template as a local Typst package. Choose the instructions for your platform below.

#### Unix (Linux / macOS)
1. Clone this repository into your local Typst packages folder:
```bash
git clone -b 0.1.1 https://gitea.linerds.us/pencelheimer/typst_nure_template.git ~/.local/share/typst/packages/local/nure/0.1.1
```
2. Init your project with Typst:
```bash
typst init @local/nure:0.1.1 project-name
```

#### Windows (symlink method)
This method creates a symbolic link between the cloned repository and Typst's local packages folder in `%APPDATA%`. The benefit: when the template is updated on GitHub you only need to `git pull` in the cloned folder — VS Code (and Typst) will use the updated files automatically.

Step 1 — clone the template (for example, into your Documents folder):
```powershell
cd $HOME\Documents
git clone https://github.com/linerds/typst_nure_template.git
```

Step 2 — create the symlink (PowerShell must be run as Administrator):
1. Open Start, find PowerShell, right-click and choose "Run as Administrator".
2. Run the following commands as a single block:
```powershell
# Create local packages folder (if it doesn't exist)
New-Item -ItemType Directory -Force -Path "$env:APPDATA\typst\packages\local\nure"

# Point to the folder you cloned
$gitFolder = "$HOME\Documents\typst_nure_template"

# Create a symbolic link for the package version (match the version in this repo)
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\typst\packages\local\nure\0.1.1" -Target $gitFolder
```

Step 3 — use in VS Code
Open your project folder (for example, your coursework or lab folder) in VS Code with the Tinymist Typst extension installed. Create `main.typ` and import the package using the official `@local` import:

```typst
#import "@local/nure:0.1.1": nure-report, style
// If you need specific style variables from the package:
#import "@local/nure:0.1.1/src/style.typ": spacing

#show: nure-report.with(
  title: "Report for Lab Work",
  type: "Lab Work #1",
  discipline: "Object-Oriented Programming",
  author: "Surname I.I.",
  supervisor: "Assoc. Prof. Kuznetsov O.V.",
)

= Work progress
Your content...
```

The Windows steps above are intentionally minimal and focused on the symlink workflow. If you prefer not to use symlinks, you can copy `src/` to your project root and import `lib.typ` directly (see the "As a standalone file" section).

### As a standalone file
Copy `src/` to your project's root directory, optionally renaming `src/` to `lib/` (then import `src/lib.typ` or `lib/lib.typ` accordingly).

### In your project
```typst
// Import the template either from a local package...
#import "@local/nure:0.1.1": *
// ...or by importing a lib.typ directly
// #import "/lib/lib.typ": *

// NOTE: all template arguments use kebab-case.

// 1. Setup the document
// by setting values directly...
#show: pz-lb.with(
  title: "Some title",
  // ...
)
// ...or using a yaml/toml file
#show: pz-lb.with(..toml("/doc.toml"))

// this template automatically inserts a `=title`

// Write your content
#v(-spacing) // remove spacing between headings
== Purpose
Some text

// ...or include your modules
#include "chapters/intro.typ"
#include "chapters/chapter1.typ"
#include "chapters/chapter2.typ"
// NOTE: if you want to use variables or utils provided by the package,
// you have to import the package or a lib.typ inside a module (e.g. #import "@local/nure:0.1.1": utils).


// If you ever need appendices in pz-lb template use the show rule
// WARNING: when using coursework template use its own argument,
// so it can put bibliography before appendices
#show: style.appendices

// For coursework appendices, pass them via `appendices:` argument instead.

= Quote
#link("https://youtu.be/bJQj1uKtnus")[
  The art isn't the art, the art is never the art,
  the art is the thing that happens inside you when you make it and the feeling in the heart of the beholder.
]
```

And a TOML file would look like this:
```toml
# university = "ХНУРЕ" # "ХНУРЕ" is the default
# edu-program = "ПЗПІ" # can be null, sourced from authors.first() by default

subject = "СМП"
doctype = "ЛБ"
worknumber = 2
title = "Потiк керування та алгоритмічні структури Bash"

[[mentors]]
name = "Шевченко Т. Г."
degree = "Доцент кафедри ПІ"
gender = "m"

[[mentors]]
name = "Франко І. Я."
degree = "Асистент кафедри ПІ"
gender = "m"

[[authors]]
name = "Косач Л. П."
edu-program = "ПЗПІ"
group = "23-2"
gender = "f"
variant = 8
# For coursework
full-name-gen = "Косач Лариси Петрівни"
course = 2
semester = 4
```

### Notes:
1. Use `#v(-spacing)` to remove vertical spacing between titles (this cannot be automatically handled by the template). Variable `spacing` used here is imported from the template.
2. When importing `@local/nure:0.1.1` and specifying file paths in functions handled by the package, the path will be relative to the package root, e.g. setting `#show: coursework.with(bib-path: "bibl.yml")` will evaluate to `~/.local/share/typst/packages/local/nure/0.1.1/bibl.yml`. The same applies to `utils.img` unless you copy `template/utils.typ` into your project root and import from there.

### Bibliography Format
The template uses a custom CSL (Citation Style Language) file located at `src/csl/dstu-3008-2015.csl` to format bibliography entries.

Supported bibliography entry types in `bibl.yml`:
- **Book**: Books with author, title, publisher, year, and page count
- **Web**: Web resources with title, author/organization, URL, and access date

**Warning:** Other types were added by Kimi K2.5 without any additional checks for compliance.

Example `bibl.yml`:
```yaml
mysql:
  type: Book
  title: MySQL Language Reference
  author: Ab M.
  publisher: MySQL Press
  date: 2004
  page-total: 600

go:
  type: Web
  title: The Go Programming Language
  author: The Go Programming Language
  url:
    value: https://go.dev/
    date: 2024-12-10
```

### Example Project Structure
```
project/
├── doc.toml -- for things that don't change across works, i.e. author and mentor metadata
├── main.typ -- for boilerplate code and importing everything 
├── utils.typ -- for helper functions
├── chapters/
│   ├── intro.typ
│   ├── chapter1.typ
│   ├── chapter2.typ
│   └── ...
├── figures/
│   ├── chapter1/
│   │   ├── figure1.png
│   │   ├── figure2.png
│   │   ├── figure3.png
│   │   └── ...
│   ├── chapter2/
│   │   ├── figure1.png
│   │   ├── figure2.png
│   │   ├── figure3.png
│   │   └── ...
│   └── ...
└── ...
```
