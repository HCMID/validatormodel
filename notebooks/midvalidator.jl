### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 9b7d76ac-4faf-11eb-17de-69db047d5f91
begin
	import Pkg
	Pkg.activate(".")
	Pkg.add("PlutoUI")
	Pkg.add("CitableText")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	Pkg.add(url="https://github.com/HCMID/CitableTeiReaders.jl")
	using PlutoUI
	using CitableText
	using CSV
	using DataFrames
	using HTTP
	using CitableTeiReaders
end

# ╔═╡ c37ed214-502b-11eb-284e-31588e9de7c4
md"Use the `Reload data` button to update your notebook."

# ╔═╡ a7acabd8-502b-11eb-326f-2725d64c5b85
@bind loadem Button("Reload data")

# ╔═╡ 6beaff5a-502b-11eb-0225-cbc0aadf69fa
md"""## Indexing in DSE tables
"""

# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
html"""<blockquote>
<h3>Adjustable settings for this repository</h3>
</blockquote>

"""

# ╔═╡ 7da35330-4d0b-11eb-3487-81d04b9d1f4a
md"""Subdirectory for XML editions:
$(@bind editions TextField(default="editions"))
"""

# ╔═╡ 97afc2a2-4d0f-11eb-3869-8ff78542ee6b
md"""Subdirectory for DSE tables:
$(@bind dsedir TextField(default="dse"))
"""

# ╔═╡ 88b55824-503f-11eb-101f-a12e4725f738
html"""<blockquote>
<h3>Cells for loading and formatting data</h3>
</blockquote>

<p>You should not normally edit contents of these cells.


"""

# ╔═╡ 527f86ea-4d0f-11eb-1440-293fc241c198
reporoot = dirname(pwd())

# ╔═╡ 8a426414-502d-11eb-1e7d-357a363bb627
catalogedtexts = begin
	loadem
	fromfile(CatalogedText, reporoot * "/" * editions * "/catalog.cex")
end

# ╔═╡ af505654-4d11-11eb-07a0-efd94c6ff985
function xmleditions()
	loadem
	filenames = filter(f -> endswith(f, "xml"), readdir(reporoot * "/" * editions))
	DataFrame( filename = filenames)
end

# ╔═╡ 62458454-502e-11eb-2a88-5ffcdf640e6b
filesonline = xmleditions()

# ╔═╡ db26554c-5029-11eb-0627-cf019fae0e9b
function hdr() 
	HTML("<blockquote  class='center'><h1>MID validation notebook</h1>" *
		"<p>Using repository in directory:</p><h4><i>" * reporoot * "</i></h4></blockquote>")
end

# ╔═╡ d9fae7aa-5029-11eb-3061-89361e04f904
hdr()

# ╔═╡ 0fea289c-4d0c-11eb-0eda-f767b124aa57
css = html"""
<style>
 .center {
text-align: center;
}
.highlight {
  background: yellow;  
}
.urn {
	color: silver;
}
  .note { -moz-border-radius: 6px;
     -webkit-border-radius: 6px;
     background-color: #eee;
     background-image: url(../Images/icons/Pencil-48.png);
     background-position: 9px 0px;
     background-repeat: no-repeat;
     border: solid 1px black;
     border-radius: 6px;
     line-height: 18px;
     overflow: hidden;
     padding: 15px 60px;
    font-style: italic;
 }
</style>
"""

# ╔═╡ 788ba1fc-4ff3-11eb-1a02-f1d099051ef5
md"""Prototyping for `EditorsRepo` 

"""

# ╔═╡ 8ea2fb34-4ff3-11eb-211d-857b2c643b61
#  CSV.File(filename, skipto=2, delim=delimiter)
function readcite()
	loadem
	arr = CSV.File(reporoot * "/" * editions * "/citation.cex", skipto=2, delim="|") |> Array
	urns = map(row -> CtsUrn(row[1]), arr)
	files = map(row -> row[2], arr)
	fnctns = map(row -> eval(Meta.parse(row[3])), arr)
	DataFrame(urn = urns, file = files, converter = fnctns)
end

# ╔═╡ 2de2b626-4ff4-11eb-0ee5-75016c78cb4b
markupschemes = readcite()

# ╔═╡ 1afc652c-4d13-11eb-1488-0bd8c3f60414
md"## Summary of text cataloging

- **$(nrow(catalogedtexts))** text(s) cataloged
- **$(nrow(markupschemes))** text(s) with a defined markup scheme
- **$(nrow(filesonline))** file(s) found in editing directory

"

# ╔═╡ 8df925ee-5040-11eb-0e16-291bc3f0f23d
nbversion = Pkg.TOML.parse(read("Project.toml", String))["version"]


# ╔═╡ d0218ccc-5040-11eb-2249-755b68e24f4b
md"Using version **$(nbversion)** of MID validation notebook"

# ╔═╡ Cell order:
# ╟─9b7d76ac-4faf-11eb-17de-69db047d5f91
# ╟─d0218ccc-5040-11eb-2249-755b68e24f4b
# ╟─d9fae7aa-5029-11eb-3061-89361e04f904
# ╟─c37ed214-502b-11eb-284e-31588e9de7c4
# ╟─a7acabd8-502b-11eb-326f-2725d64c5b85
# ╟─1afc652c-4d13-11eb-1488-0bd8c3f60414
# ╟─8a426414-502d-11eb-1e7d-357a363bb627
# ╟─62458454-502e-11eb-2a88-5ffcdf640e6b
# ╟─2de2b626-4ff4-11eb-0ee5-75016c78cb4b
# ╟─6beaff5a-502b-11eb-0225-cbc0aadf69fa
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─97afc2a2-4d0f-11eb-3869-8ff78542ee6b
# ╟─88b55824-503f-11eb-101f-a12e4725f738
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─af505654-4d11-11eb-07a0-efd94c6ff985
# ╟─db26554c-5029-11eb-0627-cf019fae0e9b
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─788ba1fc-4ff3-11eb-1a02-f1d099051ef5
# ╟─8ea2fb34-4ff3-11eb-211d-857b2c643b61
# ╟─8df925ee-5040-11eb-0e16-291bc3f0f23d
