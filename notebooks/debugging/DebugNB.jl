module DebugNB

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

export editorsrepo, catalogedtexts, catalogedurns
export diplpassages, diplnode





function editorsrepo() 
    EditingRepository( dirname(pwd()), "editions", "dse", "config")
end

function catalogedtexts(repo::EditingRepository)
	allcataloged = fromfile(CatalogedText, repo.root * "/" * repo.configs * "/catalog.cex")
	filter(row -> row.online, allcataloged)
end

function texturns(repo)
    texts = catalogedtexts(repo)
    texts[:, :urn]
end


# alldse = dse_df(editorsrepo())


function diplpassages(editorsrepo)
    urnlist = catalogedurns(editorsrepo)
	try 
		diplomaticarrays = map(u -> diplomaticnodes(editorsrepo, u), urnlist)
		singlearray = reduce(vcat, diplomaticarrays)
		filter(psg -> psg !== nothing, singlearray)
	catch e
		msg = "<div class='danger'><h1>🧨🧨 Markup error 🧨🧨</h1><p><b>$(e)</b></p></div>"
		HTML(msg)
	end
end

function diplnode(urn, diplomaticpassages)
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

function isref(urn::CtsUrn)::Bool
    # True if last part of 
    passageparts(urn)[end] == "ref"
end


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

function surfacemenu(editorsrepo)
	loadem
	surfurns = EditorsRepo.surfaces(editorsrepo)
	surflist = map(u -> u.urn, surfurns)
	# Add a blank entry so popup menu can come up without a selection
	pushfirst!( surflist, "")
end


end