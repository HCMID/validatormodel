# HC MID template repository, version` 0.3.2`


This is a template repository illustrating HC MID validation and verification using an interactive Pluto notebook.

## Status

The validating notebook is in early stages of development.  The [project issue tracker](https://github.com/HCMID/validatormodel/issues) includes a 1.0 milestone identifying issues that need to be resolved before the notebook can be considered mature enough to consider a thorough validation of cross-project MID standards for editing projects.

## Organization of repository

- `editions` XML editions
- `dse` Delimited-text files indexing edited passages to physical surfaces and documentary images.
- `notebooks` Pluto notebooks you can run to validate and verify your work.
- `config` Configuration files.  You should have corresponding entries for each text in `catalog.cex` (basic information about the text)  and `citation.cex` (information about how to parse and process each file)

## Installing Pluto notebook server

To run the Pluto notebooks in the `notebooks` directory, you need the Julia language, with the `Pluto` module installed. 

1. [Download julia](https://julialang.org/downloads/) and run the installer.
2. Start julia, and from the `julia` prompt, enter `] add Pluto` (including the right bracket!)


## Usage

You should start your basic validation notebook *before* beginning to edit.  

From a bash terminal, `cd` into the `notebooks` directory, and start `julia`. (If you're using VS Code, you can use the `Terminal` menu to open a new terminal in VS Code.) Then at the `julia` prompt, enter these two commands:

```julia
using Pluto
Pluto.run()
```

Within Pluto, open the generic `midvalidator-VERSION.jl` notebook.  If your project has additional project-specific tests, they can be managed in a second, separate notebook, so you can open that notebook as well in a separate browser tab.

To minimize the setup you have to do, the notebook is configured to download and build the entire app each time you start it.  This means you don't need to have anything else preinstalled, but it also means that startup time is slow. (It can take up to 2 minutes on an older laptop.)  Once the notebook has started, it is very responsive even on older personal machines.

## Configuration files



### Configuring the validation notebook

In the file `notebooks/MID.toml`,  define a name for your project, and the URL for its github repository in this file.

### Configuring citation scheme and parsing of texts

The file `config/catalog.cex` is a delimited-text file with an entry for each text you are editing.  The first column identifies the text by CTS URN.  The second column lists labels for each tier of the citation scheme, separated by commas. E.g., `book,line` would be an appropriate entry to cite a text like the *Iliad* by book and line.  The next four columns are labels for the text group, work, version of the text. The following column  optionally labels a specific exemplar of that version:  for manuscript material, this will normally be empty.  The seventh column should have the value `true` if the edition is available, or `false` if the text is cataloged but no edition is available.  The final column should give the three-letter code for the language of the text in ISO 639.




- `config/citation.cex`. *Documentation TBA*.


