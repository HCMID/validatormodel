# validatormodel


Sample repository for HC MID validation and verification using an interactive Pluto notebook.

Requirements:  julia.

Start julia, then:

```julia
using Pluto
Pluto.run()
```

Within Pluto, open the generic `midvalidator.jl` notebook.  If your project has additional project-specific tests, they should be managed in `projectvalidator.jl`, so open that notebook as well.