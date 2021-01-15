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

# ╔═╡ 0589b23a-5736-11eb-2cb7-8b122e101c35
begin
	import Pkg
	Pkg.activate(".")
	Pkg.add("PlutoUI")
	Pkg.add("CitableText")
	Pkg.add("CitableObject")
	Pkg.add("CitableImage")
	Pkg.add("CitableTeiReaders")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	Pkg.add("EditorsRepo")
	
	# Waiting for packages to clear Julia Registry
	Pkg.add(url="https://github.com/HCMID/EditionBuilders.jl")
	Pkg.add(url="https://github.com/HCMID/Orthography.jl")
	
	using PlutoUI
	using CitableText
	using CitableObject
	using CitableImage
	using CitableTeiReaders
	using CSV
	using DataFrames
	using HTTP
	using EditorsRepo
	
	using Markdown
	
	using EditionBuilders
	using Orthography

end

# ╔═╡ 7ee4b3a6-573d-11eb-1470-67a241783b23
@bind loadem Button("Load/reload data")

# ╔═╡ 22ab24bc-5749-11eb-04fc-898b43aa426f
md"""

> Overview of contents

"""

# ╔═╡ 6b4decf8-573b-11eb-3ef3-0196c9bb5b4b
md"**URNs of all cataloged texts**"

# ╔═╡ 4010cf78-573c-11eb-03cf-b7dd1ae23b60
md"**URNS (as Strings) of all indexed surfaces**"

# ╔═╡ 558e587a-573c-11eb-3364-632f0b0703da
md"""

> ## Verification: DSE indexing

"""

# ╔═╡ f1f5643c-573d-11eb-1fd1-99c111eb523f
md"Maximum width of image: $(@bind w Slider(200:1200, show_value=true))"


# ╔═╡ a7903abe-5747-11eb-310e-ffe2ee128f1b
md"""

> ## Data sets

"""

# ╔═╡ 61bf76b0-573c-11eb-1d23-855b40e06c02
md"""

> Text corpora built from repository

"""

# ╔═╡ 562b460a-573a-11eb-321b-678429a06c0c
md"All citable nodes in **diplomatic** form."

# ╔═╡ 9118b6d0-573a-11eb-323b-0347fef8d3e6
md"All citable nodes in **normalized** form."

# ╔═╡ 100a1942-573c-11eb-211e-371998789bfa
md"""

> DSE tables

"""

# ╔═╡ 43f724c6-573b-11eb-28d6-f9ec8adebb8a
md"""


> Full details of text catalog and configuration

"""

# ╔═╡ 0cabc908-5737-11eb-2ef9-d51aedfbbe5f
md"""

> ## Configuring the repository

"""

# ╔═╡ 6876c1d6-5749-11eb-39fe-29ef948bec69
md"Automatically computed values:"

# ╔═╡ 1053c2d8-5749-11eb-13c1-71943988978f
nbversion = Pkg.TOML.parse(read("Project.toml", String))["version"]


# ╔═╡ fef09e62-5748-11eb-0944-c983eef98e1b
md"This is version **$(nbversion)** of the MID validation notebook."

# ╔═╡ 6182ebc0-5749-11eb-01b3-e35b891381ae
projectname = Pkg.TOML.parse(read("Project.toml", String))["project"]

# ╔═╡ a7142d7e-5736-11eb-037b-5540068734e6
reporoot = dirname(pwd())

# ╔═╡ 59301396-5736-11eb-22d3-3d6538b5228c
md"""
Subdirectories in the repository:

| Content | Subdirectory |
|--- | --- |
| Configuration files are in | $(@bind configdir TextField(default="config")) |
| XML editions are in | $(@bind editions TextField(default="editions")) |
| DSE tables are in | $(@bind dsedir TextField(default="dse")) |

"""

# ╔═╡ 2fdc8988-5736-11eb-262d-9b8d44c2e2cc
catalogedtexts = begin
	loadem
	fromfile(CatalogedText, reporoot * "/" * configdir * "/catalog.cex")
end

# ╔═╡ 0bd05af4-573b-11eb-1b90-31d469940e5b
urnlist = catalogedtexts[:, :urn]

# ╔═╡ e3578474-573c-11eb-057f-27fc9eb9b519
md"This is the `EditingRepository` built from these settings:"

# ╔═╡ 7829a5ac-5736-11eb-13d1-6f5430595193
editorsrepo = EditingRepository(reporoot, editions, dsedir, configdir)

# ╔═╡ 356f7236-573c-11eb-18b5-2f5a6bfc545d
uniquesurfs = begin 
	surfurns = EditorsRepo.surfaces(editorsrepo)
	surflist = map(u -> u.urn, surfurns)
	# Add a blank entry so popup menu can come up without a selection
	pushfirst!( surflist, "")
end

# ╔═╡ e08d5418-573b-11eb-2375-35a717b36a30
md"""
*Choose a surface to verify*: 
$(@bind surface Select(uniquesurfs))
"""

# ╔═╡ 175f2e58-573c-11eb-3a36-f3142c341d93
alldse = begin
	loadem
	dse_df(editorsrepo)
end

# ╔═╡ 4fa5738a-5737-11eb-0e78-0155bfc12112
textconfig = begin
	loadem
	citation_df(editorsrepo)
end

# ╔═╡ 70ac0236-573e-11eb-1efd-c3be076018aa
md"""

> Configuring image services

"""

# ╔═╡ 97415fa4-573e-11eb-03df-81e1567ec34e
md"""
Image Citation Tool URL: 
$(@bind ict TextField((55,1), default="http://www.homermultitext.org/ict2/?"))
"""

# ╔═╡ 77a302c4-573e-11eb-311c-7102e8b377fa
md"""
IIIF URL: 
$(@bind iiif TextField((55,1), default="http://www.homermultitext.org/iipsrv"))
"""

# ╔═╡ 8afeacec-573e-11eb-3da5-6b6d6bd764f8
md"""
IIIF image root: $(@bind iiifroot TextField((55,1), default="/project/homer/pyramidal/deepzoom"))

"""

# ╔═╡ c3efd710-573e-11eb-1251-75295cced219
md"This is the IIIF Service built from these settings:"

# ╔═╡ bd95307c-573e-11eb-3325-ad08ee392a2f
# CitableImage access to a IIIF service
iiifsvc = begin
	baseurl = iiif
	root = iiifroot
	IIIFservice(baseurl, root)
end

# ╔═╡ 1fbce92e-5748-11eb-3417-579ae03a8d76
md"""

> ## Formatting the notebook

"""

# ╔═╡ 9ac99da0-573c-11eb-080a-aba995c3fbbf
md"""

> DSE selections from popup menu:

"""

# ╔═╡ 901ae238-573c-11eb-15e2-3f7611dacab7
surfurn = begin
	if surface == ""
		""
	else
		Cite2Urn(surface)
	end
end

# ╔═╡ e57c9326-573b-11eb-100c-ed7f37414d79
surfaceDse = filter(row -> row.surface == surfurn, alldse)

# ╔═╡ c9a3bd8c-573d-11eb-2034-6f608e8bf414
begin
	if surface == ""
		md""
	else
		md"*Found **$(nrow(surfaceDse))** citable text passages for $(objectcomponent(surfurn))*"
	end
end

# ╔═╡ 94a7db86-573b-11eb-0eec-8f845bec5995
md"""

> ## Temporary content
> Functions to migrate to the next release of the `EditorsRepo` module.

"""

# ╔═╡ 7a347506-5737-11eb-03bb-ef6dfa90d9c8
md"These functions compile diplomatic and normalized texts for the repository."

# ╔═╡ 8ebcdc8e-5737-11eb-00f2-e5529a12c4d2
# Read text contents of file for URN
function fileforu(urn)
	row = filter(r -> droppassage(urn) == r[:urn], textconfig)
	f= editorsrepo.root * "/" * editorsrepo.editions * "/" *	row[1,:file]
	xml = read(f, String)
end

# ╔═╡ a7b6f2f6-5737-11eb-1a43-2fa2909d0240
# Eval string value of ocho2converter for a URN
function o2foru(urn)
	row = filter(r -> droppassage(urn) == r[:urn], textconfig)
	eval(Meta.parse(row[1,:o2converter]))
end

# ╔═╡ a24430ec-573a-11eb-188d-e52c79291fcf
function normforu(urn)
	row = filter(r -> droppassage(urn) == r[:urn], textconfig)
	eval(Meta.parse(row[1,:normalized]))
end

# ╔═╡ b7dae7a0-573a-11eb-2c76-15974f79daf8
# given a node URN, 
function normalizedcns(urn)
	
	reader = o2foru(urn)
	xml =  fileforu(urn)
	corpus = reader(xml, urn)
	normalizer = normforu(urn)
	map(cn -> editednode(normalizer, cn), corpus.corpus)
end

# ╔═╡ 9974fadc-573a-11eb-10c4-13c589f5810b
normalizednodes =  begin
	normalizedarrays = map(u -> normalizedcns(u), urnlist)
	reduce(vcat, normalizedarrays)
end

# ╔═╡ b815025a-5737-11eb-3b68-0df9e43b534d
function diplforu(urn)
	row = filter(r -> droppassage(urn) == r[:urn], textconfig)
	eval(Meta.parse(row[1,:diplomatic]))
end

# ╔═╡ 75ca5ad0-5737-11eb-1a4a-17beafff6a96
# given a node URN, 
function diplomaticcns(urn)
	
	reader = o2foru(urn)
	xml =  fileforu(urn)
	corpus = reader(xml, urn)
	dipl = diplforu(urn)
	diplnodes = map(cn -> editednode(dipl, cn), corpus.corpus)
end

# ╔═╡ 2a84a042-5739-11eb-13f1-1d881f215521
diplomaticnodes = begin
	diplomaticarrays = map(u -> diplomaticcns(u), urnlist)
	reduce(vcat, diplomaticarrays)
end

# ╔═╡ 2d218414-573e-11eb-33dc-af1f2df86cf7
# Select a node from list of diplomatic nodes
function diplnode(urn)
	filtered = filter(cn -> dropversion(cn.urn) == dropversion(urn), diplomaticnodes)
	if length(filtered) > 0
		filtered[1].text
	else 
		""
	end
	#"Found stuffs " * le
end

# ╔═╡ bf77d456-573d-11eb-05b6-e51fd2be98fe
function mdForRow(row::DataFrameRow)
	citation = "**" * passagecomponent(row.passage)  * "** "

	
	txt = diplnode(row.passage)
	caption = passagecomponent(row.passage)
	
	img = linkedMarkdownImage(ict, row.image, iiifsvc, w, caption)
	
	#urn
	record = """$(citation) $(txt)
	
$(img)
	
---
"""
	record
end


# ╔═╡ 00a9347c-573e-11eb-1b25-bb15d56c1b0d
# display DSE records for verification
begin
	if surface == ""
		md""
	else
		cellout = []
		for r in eachrow(surfaceDse)
			push!(cellout, mdForRow(r))
		end
		Markdown.parse(join(cellout,"\n"))
	end
end

# ╔═╡ Cell order:
# ╟─0589b23a-5736-11eb-2cb7-8b122e101c35
# ╟─fef09e62-5748-11eb-0944-c983eef98e1b
# ╟─7ee4b3a6-573d-11eb-1470-67a241783b23
# ╟─22ab24bc-5749-11eb-04fc-898b43aa426f
# ╟─6b4decf8-573b-11eb-3ef3-0196c9bb5b4b
# ╟─0bd05af4-573b-11eb-1b90-31d469940e5b
# ╟─4010cf78-573c-11eb-03cf-b7dd1ae23b60
# ╟─356f7236-573c-11eb-18b5-2f5a6bfc545d
# ╟─558e587a-573c-11eb-3364-632f0b0703da
# ╟─e08d5418-573b-11eb-2375-35a717b36a30
# ╟─c9a3bd8c-573d-11eb-2034-6f608e8bf414
# ╟─f1f5643c-573d-11eb-1fd1-99c111eb523f
# ╟─00a9347c-573e-11eb-1b25-bb15d56c1b0d
# ╟─a7903abe-5747-11eb-310e-ffe2ee128f1b
# ╟─61bf76b0-573c-11eb-1d23-855b40e06c02
# ╟─562b460a-573a-11eb-321b-678429a06c0c
# ╟─2a84a042-5739-11eb-13f1-1d881f215521
# ╟─9118b6d0-573a-11eb-323b-0347fef8d3e6
# ╟─9974fadc-573a-11eb-10c4-13c589f5810b
# ╟─100a1942-573c-11eb-211e-371998789bfa
# ╟─175f2e58-573c-11eb-3a36-f3142c341d93
# ╟─43f724c6-573b-11eb-28d6-f9ec8adebb8a
# ╟─2fdc8988-5736-11eb-262d-9b8d44c2e2cc
# ╟─4fa5738a-5737-11eb-0e78-0155bfc12112
# ╟─0cabc908-5737-11eb-2ef9-d51aedfbbe5f
# ╟─6876c1d6-5749-11eb-39fe-29ef948bec69
# ╟─1053c2d8-5749-11eb-13c1-71943988978f
# ╟─6182ebc0-5749-11eb-01b3-e35b891381ae
# ╟─a7142d7e-5736-11eb-037b-5540068734e6
# ╟─59301396-5736-11eb-22d3-3d6538b5228c
# ╟─e3578474-573c-11eb-057f-27fc9eb9b519
# ╟─7829a5ac-5736-11eb-13d1-6f5430595193
# ╟─70ac0236-573e-11eb-1efd-c3be076018aa
# ╟─97415fa4-573e-11eb-03df-81e1567ec34e
# ╟─77a302c4-573e-11eb-311c-7102e8b377fa
# ╟─8afeacec-573e-11eb-3da5-6b6d6bd764f8
# ╟─c3efd710-573e-11eb-1251-75295cced219
# ╟─bd95307c-573e-11eb-3325-ad08ee392a2f
# ╟─1fbce92e-5748-11eb-3417-579ae03a8d76
# ╟─bf77d456-573d-11eb-05b6-e51fd2be98fe
# ╟─9ac99da0-573c-11eb-080a-aba995c3fbbf
# ╟─901ae238-573c-11eb-15e2-3f7611dacab7
# ╟─e57c9326-573b-11eb-100c-ed7f37414d79
# ╟─94a7db86-573b-11eb-0eec-8f845bec5995
# ╠═2d218414-573e-11eb-33dc-af1f2df86cf7
# ╟─7a347506-5737-11eb-03bb-ef6dfa90d9c8
# ╟─8ebcdc8e-5737-11eb-00f2-e5529a12c4d2
# ╟─a7b6f2f6-5737-11eb-1a43-2fa2909d0240
# ╟─a24430ec-573a-11eb-188d-e52c79291fcf
# ╟─b7dae7a0-573a-11eb-2c76-15974f79daf8
# ╟─b815025a-5737-11eb-3b68-0df9e43b534d
# ╟─75ca5ad0-5737-11eb-1a4a-17beafff6a96
