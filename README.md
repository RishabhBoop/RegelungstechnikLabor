# RegelungstechnikLabor

Labor für Regelungstechnik an der HKA SS26

> Wichtig: Mit `lualatex` kompilieren!!

## Usage with LaTeX Workshop (VS Code)

1. Install the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension in VS Code.
2. The workspace is configured to automatically detect the root document using magic comments. When editing section files (e.g., `lab1/a1.tex`), make sure to build the root document (`lab1/bericht.tex`).
3. Build the document using the LaTeX Workshop build command (e.g., `Ctrl+Alt+B` or through the extension's sidebar).

## Usage with Make

A `Makefile` is provided to simplify the build process from the terminal. It uses `latexmk` with the necessary flags (`-pdflua`, `-shell-escape`, etc.) and handles the naming convention for the final PDF based on the lab's `config.mk`.

### Configuration (`config.mk`)

Each lab directory (e.g., `lab1`) should contain a `config.mk` file to configure metadata for the Makefile. This file defines how the output PDF will be named. Example:

```makefile
# Configuration for this specific lab
HAUPTAUTOR = Venugopal_Rishabh
VERSUCH = Lab1
DOC = bericht.tex
```

- `HAUPTAUTOR`: Used to generate the target PDF filename (e.g., `Venugopal_Rishabh_Lab1.pdf`).
- `VERSUCH`: The experiment name, also used in the PDF filename.
- `DOC`: The main LaTeX document to compile (default is usually `bericht.tex`).

### Commands

- Compile the default lab (`lab1`):

  ```bash
  make build
  ```

- Compile a specific lab:

  ```bash
  # e.g. make build LAB=lab1
  make build LAB=<lab-folder-name>
  ```

- Clean all generated files and PDFs for a lab:

  ```bash
  make clean LAB=lab1
  ```
