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
	Pkg.add("CitableTeiReaders")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	Pkg.add("EditorsRepo")
	
	using PlutoUI
	using CitableText
	using CitableObject
	using CitableTeiReaders
	using CSV
	using DataFrames
	using HTTP
	using EditorsRepo
end

# ╔═╡ c37ed214-502b-11eb-284e-31588e9de7c4
md"Use the `Load/reload data` button to update your notebook."

# ╔═╡ a7acabd8-502b-11eb-326f-2725d64c5b85
@bind loadem Button("Load/reload data")

# ╔═╡ 6beaff5a-502b-11eb-0225-cbc0aadf69fa
md"""## 2. Indexing in DSE tables
"""

# ╔═╡ abbf895a-51b3-11eb-1bc3-f932be13133f
md"""## 3. Orthography and tokenization

> Validation and verification of orthograph: **TBA**

"""

# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
html"""<blockquote>
<h3>Adjustable settings for this repository</h3>
</blockquote>

"""

# ╔═╡ 851842f4-51b5-11eb-1ed9-ad0a6eb633d2
md"Organization of your repository"

# ╔═╡ 8fb3ae84-51b4-11eb-18c9-b5eb9e4604ed
md"""
| Content | Subdirectory |
|--- | --- |
| Configuration files are in | $(@bind configdir TextField(default="config")) |
| XML editions are in | $(@bind editions TextField(default="editions")) |
| DSE tables are in | $(@bind dsedir TextField(default="dse")) |

"""

# ╔═╡ 98d7a57a-5064-11eb-328c-2d922aecc642
md"""Delimiter for DSE tables:
$(@bind delimiter TextField(default="|"))
"""

# ╔═╡ 88b55824-503f-11eb-101f-a12e4725f738
html"""<hr/>


<blockquote>
<h3>Cells for loading and formatting data</h3>
</blockquote>

<p>You should not normally edit contents of these cells.


"""

# ╔═╡ 527f86ea-4d0f-11eb-1440-293fc241c198
reporoot = dirname(pwd())

# ╔═╡ 8a426414-502d-11eb-1e7d-357a363bb627
catalogedtexts = begin
	loadem
	fromfile(CatalogedText, reporoot * "/" * configdir * "/catalog.cex")
end

# ╔═╡ 46213fee-50fa-11eb-3a43-6b8a464b8043
editorsrepo = EditingRepository(reporoot, editions, dsedir, configdir)

# ╔═╡ 71ea41d8-514b-11eb-2735-c152214415df
dselist = begin
	loadem
	dsefiles(editorsrepo)
end

# ╔═╡ 8df925ee-5040-11eb-0e16-291bc3f0f23d
nbversion = Pkg.TOML.parse(read("Project.toml", String))["version"]


# ╔═╡ d0218ccc-5040-11eb-2249-755b68e24f4b
md"This is version **$(nbversion)** of MID validation notebook"

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

# ╔═╡ 7a07eb28-538e-11eb-3c5d-1b69f152ebd8
all_dse_files = dsefiles(editorsrepo)

# ╔═╡ 8988790a-537a-11eb-1acb-ef423c2b6096
html"""
<hr/>

<blockquote>
Prototyping for <code>EditorsRepo</code>
</blockquote>


"""

# ╔═╡ 6166ecb6-5057-11eb-19cd-59100a749001
# Fake experiment.
# in reality:
# 1. match document URNs with file names, and with parser function.
# 2. cycle those triplets, and turn into a corpus.
# 3. could then recursively concat corpora

#=
begin 
	docurn = CtsUrn("urn:cts:lycian:tl.tl56.v1:")
	fname = reporoot * "/" * editions * "/" * xmlfilenames()[1]

	xml = open(fname) do file
	    read(file, String)
	end
    c = simpleAbReader(xml, docurn)

end
=#

# ╔═╡ 6330e4ce-50f8-11eb-24ce-a1b013abf7e6
# catalogedtexts is defined above by using the `CitableText` library's
# type-parameterized `fromfile` function
catalogedtexts[:,:urn]

# ╔═╡ e6e1d182-537a-11eb-0bca-01b7966e4d19
md"""
The following one is ready to add to `EditorsRepo`:
"""

# ╔═╡ f4312ab2-51cd-11eb-3b0e-91c03f39cda4
# Read orthography configuration into a DataFrame
#
function orthography_df(repo::EditingRepository)
	arr = CSV.File(repo.root * "/" * repo.configs * "/orthography.cex", skipto=2, delim="|") |> Array
	urns = map(row -> CtsUrn(row[1]), arr)
	dipl = map(row -> eval(Meta.parse(row[2])), arr)
	normed = map(row -> eval(Meta.parse(row[3])), arr)
	DataFrame(urn = urns, diplomatic = dipl, normalized = normed)
end


# ╔═╡ 23c832b6-51ce-11eb-16b1-07c702944fda
orthography = begin
	loadem
	orthography_df(editorsrepo)
end

# ╔═╡ cb30618c-537b-11eb-01ca-3f7ca0fe2869
html"""
<hr/>

<blockquote>
Prototyping for <code>CitablePhysicalText</code> (DSE)
</blockquote>


"""

# ╔═╡ d4ffdf08-537b-11eb-0f66-71fc864661b3
md"See checklist in issues for `CitablePhysicalText` repo."

# ╔═╡ f3f7e432-537b-11eb-0d2b-57a426b595e2
html"""
<hr/>

<blockquote>
<i>Already tested in next dev branch of <code>EditorsRepo</code></i>. 

<p>
Delete when updating version of <code>EditorsRepo</code></i>.
</p>
</blockquote>


"""

# ╔═╡ 8ea2fb34-4ff3-11eb-211d-857b2c643b61
# Read citation configuration into a DataFrame
function cite_df(repo::EditingRepository)
	arr = CSV.File(repo.root * "/" * repo.configs * "/citation.cex", skipto=2, delim="|") |> Array
	urns = map(row -> CtsUrn(row[1]), arr)
	files = map(row -> row[2], arr)
	fnctns = map(row -> eval(Meta.parse(row[3])), arr)
	DataFrame(urn = urns, file = files, converter = fnctns)
end

# ╔═╡ 2de2b626-4ff4-11eb-0ee5-75016c78cb4b
markupschemes = begin
	loadem
	cite_df(editorsrepo)
end

# ╔═╡ 83cac370-5063-11eb-3654-2be7d823652c
#=
match document URNs with file names, and with parser function.

* catalogedtexts is defined above by using the `CitableText` library's
	type-parameterized `fromfile` function
* markupschemes is defined above using the `EditorsRepo` module's `cite_df` function
=# 

function editedfiles()
	configedall = innerjoin(catalogedtexts, markupschemes, on = :urn)
	configedall
end


# ╔═╡ bc9f40a4-5068-11eb-38dd-7bbb330383ab
ohco2readers = begin
	allfiles = editedfiles()
	triples = allfiles[:, [:urn, :converter, :file]]
	x = triples[1,:]
	x
end

# ╔═╡ b22fa6e6-5378-11eb-1e3b-9b5520179e73
# Create DataFrame with list of XML files
function xmlfiles_df(repository::EditingRepository)
    fnames = xmlfiles(repository)
    DataFrame(filename = fnames)
end

# ╔═╡ 62458454-502e-11eb-2a88-5ffcdf640e6b
filesonline =   begin
	loadem
	xmlfiles_df(editorsrepo)
end

# ╔═╡ 1afc652c-4d13-11eb-1488-0bd8c3f60414
md"""## 1. Summary of text cataloging

- **$(nrow(catalogedtexts))** text(s) cataloged
- **$(nrow(markupschemes))** text(s) with a defined markup scheme
- **$(nrow(filesonline))** file(s) found in editing directory
"""

#=




=#

# ╔═╡ 49444ab8-5055-11eb-3d56-67100f4dbdb9
# Read a single DSE file into a DataFrame
function readdsefile(f)
	loadem
	arr = CSV.File(f, skipto=2, delim="|") |> Array
	# text, image, surface
	urns = map(row -> CtsUrn(row[1]), arr)
	files = map(row -> Cite2Urn(row[2]), arr)
	fnctns = map(row -> Cite2Urn(row[3]), arr)
	DataFrame(urn = urns, file = files, converter = fnctns)
end 

# ╔═╡ 3a1af7f8-5055-11eb-0b66-7b0de8bb18a7
# Merge all dse into a single DataFrame
function dse_df(repository::EditingRepository)
    alldse = dsefiles(repository)
    dirpath = repository.root * "/" * repository.dse * "/"
	fullnames = map(f ->  dirpath * f, alldse)
    dfs = map(f -> readdsefile(f), fullnames)
    vcat(dfs...)
end

# ╔═╡ 7d83b94a-5392-11eb-0dd0-fb894692e19d
alldse = begin
	loadem
	dse_df(editorsrepo)
end

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
# ╟─71ea41d8-514b-11eb-2735-c152214415df
# ╟─7d83b94a-5392-11eb-0dd0-fb894692e19d
# ╟─abbf895a-51b3-11eb-1bc3-f932be13133f
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─851842f4-51b5-11eb-1ed9-ad0a6eb633d2
# ╟─8fb3ae84-51b4-11eb-18c9-b5eb9e4604ed
# ╟─98d7a57a-5064-11eb-328c-2d922aecc642
# ╟─88b55824-503f-11eb-101f-a12e4725f738
# ╟─46213fee-50fa-11eb-3a43-6b8a464b8043
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─8df925ee-5040-11eb-0e16-291bc3f0f23d
# ╟─db26554c-5029-11eb-0627-cf019fae0e9b
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╠═7a07eb28-538e-11eb-3c5d-1b69f152ebd8
# ╟─8988790a-537a-11eb-1acb-ef423c2b6096
# ╟─bc9f40a4-5068-11eb-38dd-7bbb330383ab
# ╟─6166ecb6-5057-11eb-19cd-59100a749001
# ╟─6330e4ce-50f8-11eb-24ce-a1b013abf7e6
# ╟─83cac370-5063-11eb-3654-2be7d823652c
# ╟─e6e1d182-537a-11eb-0bca-01b7966e4d19
# ╟─23c832b6-51ce-11eb-16b1-07c702944fda
# ╟─f4312ab2-51cd-11eb-3b0e-91c03f39cda4
# ╟─cb30618c-537b-11eb-01ca-3f7ca0fe2869
# ╟─d4ffdf08-537b-11eb-0f66-71fc864661b3
# ╟─f3f7e432-537b-11eb-0d2b-57a426b595e2
# ╟─8ea2fb34-4ff3-11eb-211d-857b2c643b61
# ╟─b22fa6e6-5378-11eb-1e3b-9b5520179e73
# ╟─3a1af7f8-5055-11eb-0b66-7b0de8bb18a7
# ╟─49444ab8-5055-11eb-3d56-67100f4dbdb9
