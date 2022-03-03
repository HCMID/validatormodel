# HC MID template repository, version `0.17.0`

This is a template repository illustrating HC MID validation and verification.

Current documentation for setting up and working with an editing repository based on or copied from this model is available at <https://hcmid.github.io/tutorial2021/>.


## Validating an editorial repository

The current release includes two interactive options for validaing and verifying your editorial work.  The preferred method is to use the dashboard app in the `dashboard` directory; alternatively, you can use the Pluto notebook in the `notebooks` directory.


### Using the dashboard


#### Starting from VS Code

Make sure you have the Julia plugin for VS code installed.

- open this repository, and find the dashboard you want to run
- option-click anywhere in the file

#### Starting from the command line

From a terminal (in VS Code or a separate termainal app), you can start the dashboard with:

    julia --project=dashboard dashboard/validatordashboard.jl

#### Viewing the dashboard

Open a browser to `http://localhost:8051`.




### Using the Pluto notebook


The validating notebook uses Pluto's package management system (introduced in version 0.15 of Pluto), and works from the current release version of all packages it depends on.


- start Pluto (at a julia prompt, `using Pluto`, then `Pluto.run()`)
- from the page that opens in your web browser, navigate to open `notebooks/validator.VERSION.jl`


## Roadmap to 1.0

The validating code library is still under development.  The [project issue tracker](https://github.com/HCMID/validatormodel/issues) includes a [1.0 milestone](https://github.com/HCMID/validatormodel/milestone/1) listing issues that define a 1.0 standard for cross-project validation of MID standards.


- [x] `v0.16.0`: rewrite using updated packages.  Verification of DSE indexing and of configurable orthography.
- [x] `v0.17.0`: dashboard uses updated packages.
- [ ] `v1.0.0`:  comprehensive validation of configuration data, and of referential integrity in indexing and editing.


