# HC MID template repository, version` 0.1.0`



Template repository illustrating HC MID validation and verification using an interactive Pluto notebook.


## Organization of repository

- `editions` XML editions, cataloged in `catalog.cex`, with information about how to parse the citation scheme of each file in `citation.cex`
- `dse` Delimite-text files indexing edited passages to physical surfaces and documentary images.
- `notebooks` Pluto notebooks you can run to validate and verify your work.
- `config` Configuration files.

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

Within Pluto, open the generic `midvalidator.jl` notebook.  If your project has additional project-specific tests, they should be managed in `projectvalidator.jl`, so you can open that notebook as well.

The notebook will take a long time to start up, since it basically has to download and build a validating app in your browser, but once it has started, it has very responsive on everyday machines.

## Configuration files

TBA