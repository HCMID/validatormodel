### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ d859973a-78f0-11eb-05a4-13dba1f0cb9e
# build environment
begin
	import Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	

	using PlutoUI
	using CitableText
	using CitableObject
	using CitableImage
	using CitableTeiReaders
	using CSV
	using DataFrames
	using EditionBuilders
	using EditorsRepo
	using HTTP
	using Lycian
	using Markdown
	using Orthography
	using PolytonicGreek
	Pkg.status()
end

# ╔═╡ 493a315c-78f2-11eb-08e1-137d9a802802
md"UI"

# ╔═╡ 1e9d6620-78f3-11eb-3f66-7748e8758e08
@bind loadem Button("Load/reload data")

# ╔═╡ fc25dd3e-78f2-11eb-22a8-edd5a1f0470d
md"Examples of using fundamentals"

# ╔═╡ 6db097fc-78f1-11eb-0713-59bf9132af2e
md"Fundamentals"

# ╔═╡ 54a24382-78f1-11eb-24c8-198fc54ef67e
# Create EditingRepository for this notebook's repository
function editorsrepo() 
    EditingRepository( dirname(pwd()), "editions", "dse", "config")
end

# ╔═╡ 669b0cc2-78f1-11eb-1050-eb5f80ff9aba
editorsrepo()

# ╔═╡ 7f130fb6-78f1-11eb-3143-a7208d3a9559
# Build a dataframe for catalog of all online texts
function catalogedtexts(repo::EditingRepository)
	allcataloged = fromfile(CatalogedText, repo.root * "/" * repo.configs * "/catalog.cex")
	filter(row -> row.online, allcataloged)
end

# ╔═╡ 9ef502ec-78f1-11eb-308d-abdbcfe66b77
editorsrepo() |> catalogedtexts |> nrow

# ╔═╡ e45a445c-78f1-11eb-3ef5-81b1b7adec63
# Find CTS URNs of all texts cataloged as online
function texturns(repo)
    texts = catalogedtexts(repo)
    texts[:, :urn]
end

# ╔═╡ e932b090-78f1-11eb-1f6c-2bd2a2805e5a
editorsrepo() |> texturns

# ╔═╡ 1829efee-78f2-11eb-06bd-ddad8fb26622

function diplpassages(editorsrepo)
    urnlist = texturns(editorsrepo)
	try 
		diplomaticarrays = map(u -> diplomaticnodes(editorsrepo, u), urnlist)
		singlearray = reduce(vcat, diplomaticarrays)
		filter(psg -> psg !== nothing, singlearray)
	catch e
		msg = "<div class='danger'><h1>🧨🧨 Markup error 🧨🧨</h1><p><b>$(e)</b></p></div>"
		HTML(msg)
	end
end

# ╔═╡ 2cad3228-78f2-11eb-37ec-03356d4f3f35
editorsrepo() |> diplpassages

# ╔═╡ b30ccd06-78f2-11eb-2b03-8bff7ab09aa6
# True if last component of CTS URN passage is "ref"
function isref(urn::CtsUrn)::Bool
    # True if last part of 
    passageparts(urn)[end] == "ref"
end

# ╔═╡ 5c472d86-78f2-11eb-2ead-5196f07a5869
# Collect diplomatic text for 
function diplnode(urn, repo)
	diplomaticpassages = repo |> diplpassages
	generalized = dropversion(urn)
	filtered = filter(cn -> urncontains(generalized, dropversion(cn.urn)), diplomaticpassages)
	#filtered = filter(cn -> dropversion(cn.urn) == dropversion(urn), diplomaticpassages)
    dropref = filter(cn -> ! isref(cn.urn), filtered)
    
	if length(dropref) > 0
        content = collect(map(n -> n.text, dropref))
        join(content, "\n")
		#filtered[1].text
	else 
		""
	end
end

# ╔═╡ 59496248-78f2-11eb-13f0-29da2e554f5f
diplnode(CtsUrn("urn:cts:greekLit:tlg5026.e3.hmt:"), editorsrepo())

# ╔═╡ 58cdfb8e-78f3-11eb-2adb-7518ff306e2a
# Find surfaces in reposistory
function uniquesurfaces(editorsrepo)
	
	try
		EditorsRepo.surfaces(editorsrepo)
	catch e
		msg = """<div class='danger'><h2>🧨🧨 Configuration error 🧨🧨</h2>
		<p><b>$(e)</b></p></div>
		"""
		HTML(msg)
	end
end

# ╔═╡ 6482a0ea-78f3-11eb-1f0d-b9803c01e70c
editorsrepo() |> uniquesurfaces

# ╔═╡ a1c93e66-78f3-11eb-2ffc-3f5becceedc8
#Create list of text labels for popupmenu
function surfacemenu(editorsrepo)
	loadem
	surfurns = EditorsRepo.surfaces(editorsrepo)
	surflist = map(u -> u.urn, surfurns)
	# Add a blank entry so popup menu can come up without a selection
	pushfirst!( surflist, "")
end

# ╔═╡ c91e8142-78f3-11eb-3410-0d65bfb93f0a
md"""###  Choose a surface to verify

$(@bind surface Select(surfacemenu(editorsrepo())))
"""

# ╔═╡ af847106-78f3-11eb-153b-0312f0390fdc
editorsrepo() |> surfacemenu

# ╔═╡ Cell order:
# ╟─d859973a-78f0-11eb-05a4-13dba1f0cb9e
# ╟─493a315c-78f2-11eb-08e1-137d9a802802
# ╟─1e9d6620-78f3-11eb-3f66-7748e8758e08
# ╟─c91e8142-78f3-11eb-3410-0d65bfb93f0a
# ╟─fc25dd3e-78f2-11eb-22a8-edd5a1f0470d
# ╟─669b0cc2-78f1-11eb-1050-eb5f80ff9aba
# ╠═9ef502ec-78f1-11eb-308d-abdbcfe66b77
# ╟─e932b090-78f1-11eb-1f6c-2bd2a2805e5a
# ╟─2cad3228-78f2-11eb-37ec-03356d4f3f35
# ╟─59496248-78f2-11eb-13f0-29da2e554f5f
# ╠═6482a0ea-78f3-11eb-1f0d-b9803c01e70c
# ╠═af847106-78f3-11eb-153b-0312f0390fdc
# ╟─6db097fc-78f1-11eb-0713-59bf9132af2e
# ╟─54a24382-78f1-11eb-24c8-198fc54ef67e
# ╟─7f130fb6-78f1-11eb-3143-a7208d3a9559
# ╟─e45a445c-78f1-11eb-3ef5-81b1b7adec63
# ╟─1829efee-78f2-11eb-06bd-ddad8fb26622
# ╟─5c472d86-78f2-11eb-2ead-5196f07a5869
# ╟─b30ccd06-78f2-11eb-2b03-8bff7ab09aa6
# ╟─58cdfb8e-78f3-11eb-2adb-7518ff306e2a
# ╠═a1c93e66-78f3-11eb-2ffc-3f5becceedc8
