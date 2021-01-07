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
	Pkg.add("CitableObject")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	# Not yet in registry
	Pkg.add(url="https://github.com/HCMID/CitableTeiReaders.jl")
	Pkg.add(url="https://github.com/HCMID/EditorsRepo.jl")
	using PlutoUI
	using CitableText
	using CitableObject
	using CSV
	using DataFrames
	using HTTP
	using CitableTeiReaders
	using EditorsRepo
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

# ╔═╡ 98d7a57a-5064-11eb-328c-2d922aecc642
md"""Delimiter for DSE tables:
$(@bind delimiter TextField((3,1), default="|"))
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

# ╔═╡ 46213fee-50fa-11eb-3a43-6b8a464b8043
editorsrepo = EditingRepository(reporoot, editions, dsedir)

# ╔═╡ 8df925ee-5040-11eb-0e16-291bc3f0f23d
nbversion = Pkg.TOML.parse(read("Project.toml", String))["version"]


# ╔═╡ d0218ccc-5040-11eb-2249-755b68e24f4b
md"Using version **$(nbversion)** of MID validation notebook"

# ╔═╡ af505654-4d11-11eb-07a0-efd94c6ff985
function xmleditions()
	loadem
	#filenames = filter(f -> endswith(f, "xml"), readdir(reporoot * "/" * editions))
	DataFrame( filename = xmlfilenames())
end

# ╔═╡ 62458454-502e-11eb-2a88-5ffcdf640e6b
filesonline = xmleditions()

# ╔═╡ 0c1bd986-5059-11eb-128f-ab73320d2bf4
xmlfilenames = function()
	loadem
	filenames = filter(f -> endswith(f, "xml"), readdir(reporoot * "/" * editions))
	filenames
end


# ╔═╡ 14889dce-5055-11eb-1da8-adf98e2e5885
# Collect names of all .cex files in DSE directory.
function dsefiles()
	loadem
	filenames = filter(f -> endswith(f, "cex"), readdir(reporoot * "/" * dsedir))
	filenames
end

# ╔═╡ db26554c-5029-11eb-0627-cf019fae0e9b
# Format HTML header for notebook.
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
md"""---

Prototyping for `EditorsRepo`  and `CitablePhysicalText` (DSE)

"""

# ╔═╡ 8ea2fb34-4ff3-11eb-211d-857b2c643b61
# Read citation configuration into a DataFrame
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

# ╔═╡ 49444ab8-5055-11eb-3d56-67100f4dbdb9
# Read a single DSE file into a DataFrame
function readdse(f)
	loadem
	arr = CSV.File(f, skipto=2, delim="|") |> Array
	# text, image, surface
	urns = map(row -> CtsUrn(row[1]), arr)
	files = map(row -> Cite2Urn(row[2]), arr)
	fnctns = map(row -> Cite2Urn(row[3]), arr)
	DataFrame(urn = urns, file = files, converter = fnctns)
end 

# ╔═╡ 3a1af7f8-5055-11eb-0b66-7b0de8bb18a7
# Fake experiment.
# In reality, need to concat all CEX data into a single dataframe.
dse_df = begin 
	alldse = dsefiles()
	fullnames = map(f -> reporoot * "/" * dsedir * "/" * f, alldse)
	dfs = map(f -> readdse(f), fullnames)
	#	onedf = readdse(reporoot * "/" * dsedir * "/" * alldse[1])
	#onedf
	alldfs = vcat(dfs)
	#typeof(alldfs)
	alldfs
end

# ╔═╡ 38375cea-5057-11eb-1829-b103c0831bf6
length(dse_df)

# ╔═╡ 83cac370-5063-11eb-3654-2be7d823652c
#=
match document URNs with file names, and with parser function.
=#

function editedfiles()
	configedall = innerjoin(catalogedtexts, markupschemes, on = :urn)
	configedall
end


# ╔═╡ 0ab5e022-5064-11eb-3362-df6eafabca6b
editedfiles()

# ╔═╡ 42b03540-5064-11eb-19a6-37738914ba06
triplets = function()
	loadem
	allfiles = editedfiles()
	triples = allfiles[:, [:urn, :converter, :file]]
	triples[1,:]
	# one row:
	#onetriple = triples[1,:]
	#onetriple
end

# ╔═╡ bc9f40a4-5068-11eb-38dd-7bbb330383ab
begin
	allfiles = editedfiles()
	triples = allfiles[:, [:urn, :converter, :file]]
	x = triples[1,:]
	x
end

# ╔═╡ 6166ecb6-5057-11eb-19cd-59100a749001
# Fake experiment.
# in reality:
# 1. match document URNs with file names, and with parser function.
# 2. cycle those triplets, and turn into a corpus.
# 3. could then recursively concat corpora
begin 
	docurn = CtsUrn("urn:cts:lycian:tl.tl56.v1:")
	fname = reporoot * "/" * editions * "/" * xmlfilenames()[1]

	xml = open(fname) do file
	    read(file, String)
	end
    c = simpleAbReader(xml, docurn)

end

# ╔═╡ 6330e4ce-50f8-11eb-24ce-a1b013abf7e6
catalogedtexts[:,:urn]

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
# ╟─98d7a57a-5064-11eb-328c-2d922aecc642
# ╟─88b55824-503f-11eb-101f-a12e4725f738
# ╟─46213fee-50fa-11eb-3a43-6b8a464b8043
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─8df925ee-5040-11eb-0e16-291bc3f0f23d
# ╟─af505654-4d11-11eb-07a0-efd94c6ff985
# ╟─0c1bd986-5059-11eb-128f-ab73320d2bf4
# ╠═14889dce-5055-11eb-1da8-adf98e2e5885
# ╟─db26554c-5029-11eb-0627-cf019fae0e9b
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─788ba1fc-4ff3-11eb-1a02-f1d099051ef5
# ╠═8ea2fb34-4ff3-11eb-211d-857b2c643b61
# ╠═3a1af7f8-5055-11eb-0b66-7b0de8bb18a7
# ╠═38375cea-5057-11eb-1829-b103c0831bf6
# ╟─49444ab8-5055-11eb-3d56-67100f4dbdb9
# ╠═0ab5e022-5064-11eb-3362-df6eafabca6b
# ╠═83cac370-5063-11eb-3654-2be7d823652c
# ╠═42b03540-5064-11eb-19a6-37738914ba06
# ╠═bc9f40a4-5068-11eb-38dd-7bbb330383ab
# ╠═6166ecb6-5057-11eb-19cd-59100a749001
# ╠═6330e4ce-50f8-11eb-24ce-a1b013abf7e6
