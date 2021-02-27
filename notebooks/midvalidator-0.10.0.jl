### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

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

# ╔═╡ 4eeb892a-78f2-11eb-36ba-6bac3fdaf5ec


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

# ╔═╡ Cell order:
# ╟─d859973a-78f0-11eb-05a4-13dba1f0cb9e
# ╠═669b0cc2-78f1-11eb-1050-eb5f80ff9aba
# ╠═9ef502ec-78f1-11eb-308d-abdbcfe66b77
# ╠═e932b090-78f1-11eb-1f6c-2bd2a2805e5a
# ╠═2cad3228-78f2-11eb-37ec-03356d4f3f35
# ╠═59496248-78f2-11eb-13f0-29da2e554f5f
# ╟─493a315c-78f2-11eb-08e1-137d9a802802
# ╠═4eeb892a-78f2-11eb-36ba-6bac3fdaf5ec
# ╟─6db097fc-78f1-11eb-0713-59bf9132af2e
# ╟─54a24382-78f1-11eb-24c8-198fc54ef67e
# ╟─7f130fb6-78f1-11eb-3143-a7208d3a9559
# ╟─e45a445c-78f1-11eb-3ef5-81b1b7adec63
# ╟─1829efee-78f2-11eb-06bd-ddad8fb26622
# ╟─5c472d86-78f2-11eb-2ead-5196f07a5869
# ╟─b30ccd06-78f2-11eb-2b03-8bff7ab09aa6
