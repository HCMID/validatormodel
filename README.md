# validatormodel


Sample repository for HC MID validation and verification using an interactive Pluto notebook.

Requirements:  julia.

From a terminal `cd` into the `notebooks` directory, and run `julia`. Then at the `julia` prompt, enter these two commands:

```julia
using Pluto
Pluto.run()
```

Within Pluto, open the generic `midvalidator.jl` notebook.  If your project has additional project-specific tests, they should be managed in `projectvalidator.jl`, so open that notebook as well.