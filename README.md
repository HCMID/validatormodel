# validatormodel


Sample repository for HC MID validation and verification using an interactive Pluto notebook.


## Installation

Requirements:  julia, with the `Pluto` module installed. 

1. [Download julia](https://julialang.org/downloads/)
2. Start julia, and from the `julia` prompt, enter `] add Pluto` (including the right bracket!)


## Usage

From a bash terminal, `cd` into the `notebooks` directory, and start `julia`. Then at the `julia` prompt, enter these two commands:

```julia
using Pluto
Pluto.run()
```

Within Pluto, open the generic `midvalidator.jl` notebook.  If your project has additional project-specific tests, they should be managed in `projectvalidator.jl`, so open that notebook as well.