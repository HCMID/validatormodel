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
	using PlutoUI
	using CitableText
	using CSV
	using DataFrames
	using HTTP
end

# ╔═╡ 5c5d9426-4d0b-11eb-2eee-d11655453f29
md"# MID validator notebook
"

# ╔═╡ c37ed214-502b-11eb-284e-31588e9de7c4
md"Use the `Reload data` button to update your notebook."

# ╔═╡ a7acabd8-502b-11eb-326f-2725d64c5b85
@bind loadem Button("Reload data")

# ╔═╡ 1afc652c-4d13-11eb-1488-0bd8c3f60414
md"## Summary of texts

Text catalog:"

# ╔═╡ 6beaff5a-502b-11eb-0225-cbc0aadf69fa
md"""## Indexing in DSE tables
"""

# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
html"""<blockquote>
<h2>Settings for this notebook</h2>
</blockquote>

<h3>Directory organization</h3>


"""

# ╔═╡ 7da35330-4d0b-11eb-3487-81d04b9d1f4a
md"""Subdirectory for XML editions:
$(@bind editions TextField(default="editions"))
"""

# ╔═╡ 97afc2a2-4d0f-11eb-3869-8ff78542ee6b
md"""Subdirectory for DSE tables:
$(@bind dsedir TextField(default="dse"))
"""

# ╔═╡ 50c8bdb4-4d12-11eb-262d-73b0553b6364
md"""
---

Organizing contents
"""

# ╔═╡ 527f86ea-4d0f-11eb-1440-293fc241c198
reporoot = dirname(pwd())

# ╔═╡ af505654-4d11-11eb-07a0-efd94c6ff985
xmleditions = begin
	filter(f -> endswith(f, "xml"), readdir(reporoot * "/" * editions))
end

# ╔═╡ 86f739ee-4d12-11eb-28bf-85a424c369e7
editionslist = begin
	items = map(ed -> "<li>" * ed * "</li>", xmleditions)
	HTML("<p>Your editions:</p><ul>" * join(items, "\n") * "</ul>")
end

# ╔═╡ e8a5ddb0-4d0d-11eb-39c5-01602f517042
editionslist

# ╔═╡ 4618a496-4ff2-11eb-0dd0-d1390252fbd1
catalog = begin
	
	filename = reporoot * "/" * editions * "/catalog.cex"
	#=
	arr = CSV.File(filename, skipto=2, delim="|") |> Array
	cataloged = map(row -> catalog(row), arr)	
	cataloged
	=#
	fromfile(CatalogedText, filename, "|")
end


# ╔═╡ 124b4904-4ff3-11eb-316a-d76573925421
typeof(catalog)

# ╔═╡ 0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
md"""
---
Formatting
"""

# ╔═╡ db26554c-5029-11eb-0627-cf019fae0e9b
function hdr() 
	HTML("<blockquote><p class='center'>Validating project repository in directory:</p><h4 class='center'><i>" * reporoot * "</i></h4></blockquote>")
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
	fnctns = map(row -> row[3], arr)
	DataFrame(urn = urns, file = files, converter = fnctns)
end

# ╔═╡ 2de2b626-4ff4-11eb-0ee5-75016c78cb4b
cite = readcite()

# ╔═╡ 6fd51a50-4ff8-11eb-0379-7d2c19a9c2d6
typeof(cite)

# ╔═╡ Cell order:
# ╟─9b7d76ac-4faf-11eb-17de-69db047d5f91
# ╟─5c5d9426-4d0b-11eb-2eee-d11655453f29
# ╟─d9fae7aa-5029-11eb-3061-89361e04f904
# ╟─c37ed214-502b-11eb-284e-31588e9de7c4
# ╟─a7acabd8-502b-11eb-326f-2725d64c5b85
# ╟─1afc652c-4d13-11eb-1488-0bd8c3f60414
# ╟─2de2b626-4ff4-11eb-0ee5-75016c78cb4b
# ╟─e8a5ddb0-4d0d-11eb-39c5-01602f517042
# ╟─6beaff5a-502b-11eb-0225-cbc0aadf69fa
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─97afc2a2-4d0f-11eb-3869-8ff78542ee6b
# ╟─50c8bdb4-4d12-11eb-262d-73b0553b6364
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─af505654-4d11-11eb-07a0-efd94c6ff985
# ╟─86f739ee-4d12-11eb-28bf-85a424c369e7
# ╠═4618a496-4ff2-11eb-0dd0-d1390252fbd1
# ╠═124b4904-4ff3-11eb-316a-d76573925421
# ╟─0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
# ╟─db26554c-5029-11eb-0627-cf019fae0e9b
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─788ba1fc-4ff3-11eb-1a02-f1d099051ef5
# ╠═8ea2fb34-4ff3-11eb-211d-857b2c643b61
# ╠═6fd51a50-4ff8-11eb-0379-7d2c19a9c2d6
