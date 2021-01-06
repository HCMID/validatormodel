# `validatormodel`, version `0.1.0`


Template repository illustrating HC MID validation and verification using an interactive Pluto notebook.


## Installation

Requirements:  julia, with the `Pluto` module installed. 

1. [Download julia](https://julialang.org/downloads/)
2. Start julia, and from the `julia` prompt, enter `] add Pluto` (including the right bracket!)


## Usage

From a bash terminal, `cd` into the `notebooks` directory, and start `julia`. (If you're using VS Code, you can use the `Terminal` menu to open a new terminal in VS Code.) Then at the `julia` prompt, enter these two commands:

```julia
using Pluto
Pluto.run()
```

Within Pluto, open the generic `midvalidator.jl` notebook.  If your project has additional project-specific tests, they should be managed in `projectvalidator.jl`, so open that notebook as well.