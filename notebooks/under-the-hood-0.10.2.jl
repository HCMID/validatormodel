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

# ╔═╡ 3766b28a-79be-11eb-2731-b55581ccd19f
md"Activate the notebook's environment, load all libraries, use  `Pkg.status()` to display version numbers of all libraries in the terminal where you started Pluto."

# ╔═╡ 1fd65eae-79be-11eb-1599-875ca1d8e6f4
md"># Under the hood of the MID validator notebook"

# ╔═╡ 7c67cacc-79be-11eb-3fad-fd9950e55117
md"""
This notebook includes illustrative examples of the functions used in the MID validating notebook.

For legibility, the examples use Julia's pipe operator `|>` when the functions take only one parameter.

"""

# ╔═╡ 4aacb152-79b2-11eb-349a-cfe86f526399
begin
	# Read MID.toml
	github = Pkg.TOML.parse(read("MID.toml", String))["github"]
	projectname =	Pkg.TOML.parse(read("MID.toml", String))["projectname"]
	# Read Project.toml
	notebookversion = Pkg.TOML.parse(read("Project.toml", String))["version"]
	
	md"""
This notebook is using libraries defined in version **$(notebookversion)** of the MID validation notebook.
	
- We read `MID.toml` to find values for github (*$(github)*) and project name (*$(projectname)*).
- We read `Project.toml` to find the current version value (*$(notebookversion)*).
- We know the notebook is in a subdirectory of the repository root, so we use the notebook's parent directory as our base directory. (*$(dirname(pwd()))*).
	
"""	
end


# ╔═╡ a85774e6-79b9-11eb-1fc8-030922c3d600
md"""

> ### Repositories and image services to use

"""

# ╔═╡ 9d9b8144-79b8-11eb-2545-573129e6b22b
md"> The functions"

# ╔═╡ 54a24382-78f1-11eb-24c8-198fc54ef67e
# Create EditingRepository for this notebook's repository
function editorsrepo() 
    EditingRepository( dirname(pwd()), "editions", "dse", "config")
end

# ╔═╡ cc19dac4-78f6-11eb-2269-453e2b1664fd
function ict()
	"http://www.homermultitext.org/ict2/?"
end

# ╔═╡ d1969604-78f6-11eb-3231-1570919758aa
function iiifsvc()
	IIIFservice("http://www.homermultitext.org/iipsrv",
	"/project/homer/pyramidal/deepzoom"
		)
end

# ╔═╡ f2f717e2-79b9-11eb-2868-1d7dd6157b38
md"> Examples"

# ╔═╡ fbfd4d66-79b9-11eb-2022-b73a3729367c
editorsrepo()

# ╔═╡ 0384f280-79ba-11eb-253b-07208c459884
ict()

# ╔═╡ 060202ca-79ba-11eb-0e42-bdaf0f165118
iiifsvc()

# ╔═╡ fbd9d710-79ba-11eb-2c14-4d479ee0bbfd
md"> ### Texts in the repository"

# ╔═╡ d10a6d0a-79b9-11eb-3a98-a95112fa0f3b
md"> The functions"

# ╔═╡ 7f130fb6-78f1-11eb-3143-a7208d3a9559
# Build a dataframe for catalog of all online texts
function catalogedtexts(repo::EditingRepository)
	allcataloged = fromfile(CatalogedText, repo.root * "/" * repo.configs * "/catalog.cex")
	filter(row -> row.online, allcataloged)
end

# ╔═╡ e45a445c-78f1-11eb-3ef5-81b1b7adec63
# Find CTS URNs of all texts cataloged as online
function texturns(repo)
    texts = catalogedtexts(repo)
    texts[:, :urn]
end

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

# ╔═╡ 85119632-7903-11eb-3291-078d8c56087c
function normedpassages(editorsrepo)
    urnlist = texturns(editorsrepo)
	try 
		normedarrays = map(u -> normalizednodes(editorsrepo, u), urnlist)
		singlearray = reduce(vcat, normedarrays)
		filter(psg -> psg !== nothing, singlearray)
	catch e
		msg = "<div class='danger'><h1>🧨🧨 Markup error 🧨🧨</h1><p><b>$(e)</b></p></div>"
		HTML(msg)
	end
end

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

# ╔═╡ 81656522-7903-11eb-2ed7-53a05f05ebd6

# Select a node from list of normalized nodes
function normednode(urn, repo)
	normalizedpassages = repo |> normedpassages
    generalized = dropversion(urn)
    filtered = filter(cn -> urncontains(generalized, dropversion(cn.urn)), normalizedpassages)
	#filtered = filter(cn -> generalized == dropversion(urn), normalizedpassages)
    dropref = filter(cn -> ! isref(cn.urn), filtered)
    
	if length(dropref) > 0
        content = collect(map(n -> n.text, dropref))
        join(content, "\n")
		#filtered[1].text
	else 
		""
	end
end

# ╔═╡ 202e654e-79ba-11eb-2836-efb2152d7096
md"> Examples"

# ╔═╡ 24fc269c-79ba-11eb-052f-8b45ca87b55c
editorsrepo() |> catalogedtexts

# ╔═╡ 460bce32-79ba-11eb-09de-7bb98dc9127b
editorsrepo() |> texturns

# ╔═╡ 57c4528e-79ba-11eb-0b2e-e11240803f48
editorsrepo() |> diplpassages

# ╔═╡ 711b6876-79ba-11eb-0882-815f8c4d0000
editorsrepo() |> normedpassages

# ╔═╡ 9e9db4f2-79ba-11eb-0ec5-35c7d95dcdca
diplnode(CtsUrn("urn:cts:greekLit:tlg5026.e3.hmt:"), editorsrepo())

# ╔═╡ a2efcc70-79ba-11eb-0e1d-dddac9e39f26
normednode(CtsUrn("urn:cts:greekLit:tlg5026.e3.hmt:"), editorsrepo())

# ╔═╡ dc194b30-79b9-11eb-3fe8-7fc1930bd1b9
md"> ### DSE indexing"

# ╔═╡ dc63a172-79bd-11eb-11cc-0be16699050f
md"> The functions"

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

# ╔═╡ 37e5ea20-78f4-11eb-1dff-c36418158c7c
function surfaceDse(surfurn, repo)
    alldse = dse_df(editorsrepo())
	filter(row -> row.surface == surfurn, alldse)
end

# ╔═╡ 36599fea-7902-11eb-2524-3bd9026f017c
# Find URN for a single node from DSE record, which could
# include a range with subrefs within a single node.
function baseurn(urn::CtsUrn)
	trimmed = CitableText.dropsubref(urn)
	if CitableText.isrange(trimmed)
		psg = CitableText.rangebegin(trimmed)
		CitableText.addpassage(urn,psg)
	else
		urn
	end
end

# ╔═╡ e4ad8aa0-79bd-11eb-34e9-ab87b28f3654
md"> Examples"

# ╔═╡ 00d8bd66-79bf-11eb-1c5e-677cff39c0d1
editorsrepo() |> uniquesurfaces

# ╔═╡ eb5549ba-79bd-11eb-11bf-f3988bc74b5d
md"> ### Visualizations for verification"

# ╔═╡ f65ca3c6-79bd-11eb-2ced-77d6774b4ca7
md"> The functions"

# ╔═╡ a1c93e66-78f3-11eb-2ffc-3f5becceedc8
#Create list of text labels for popupmenu
function surfacemenu(editorsrepo)
	#loadem
	surfurns = EditorsRepo.surfaces(editorsrepo)
	surflist = map(u -> u.urn, surfurns)
	# Add a blank entry so popup menu can come up without a selection
	pushfirst!( surflist, "")
end

# ╔═╡ 283df9ae-7904-11eb-1b77-b74be19a859c
# Wrap tokens with invalid orthography in HTML tag
function formatToken(ortho, s)
	
	if validstring(ortho, s)
			s
	else
		"""<span class='invalid'>$(s)</span>"""
	end
end

# ╔═╡ 442b37f6-791a-11eb-16b7-536a71aee034
# Compose an HTML string for a row of tokens
function tokenizeRow(row, editorsrepo)
    textconfig = citation_df(editorsrepo)


	reduced = baseurn(row.passage)
	citation = "<b>" * passagecomponent(reduced)  * "</b> "
	ortho = orthographyforurn(textconfig, reduced)
	
	if ortho === nothing
		"<p class='warn'>⚠️  $(citation). No text configured</p>"
	else
	
		txt = normednode(reduced, editorsrepo)
		
		tokens = ortho.tokenizer(txt)
		highlighted = map(t -> formatToken(ortho, t.text), tokens)
		html = join(highlighted, " ")
		
		#"<p>$(citation) $(html)</p>"
		"<p><b>$(reduced.urn)</b> $(html)</p>"
	
	end
end

# ╔═╡ 06d139d4-78f5-11eb-0247-df4126777208
# Compose markdown for one row of display interleaving citable
# text passage and indexed image.
function mdForDseRow(row::DataFrameRow)
	citation = "**" * passagecomponent(row.passage)  * "** "

	
	txt = diplnode(row.passage, editorsrepo())
	caption = passagecomponent(row.passage)
	
	img = linkedMarkdownImage(ict(), row.image, iiifsvc(), w, caption)
	
	#urn
	record = """$(citation) $(txt)

$(img)

---
"""
	record
end

# ╔═╡ 0150956a-78f8-11eb-3ebd-793eefb046cb

# Compose markdown for thumbnail images linked to ICT with overlay of all
# DSE regions.
function completenessView(urn, repo)
     
	# Group images with ROI into a dictionary keyed by image
	# WITHOUT RoI.
	grouped = Dict()
	for row in eachrow(surfaceDse(urn, repo))
		trimmed = CitableObject.dropsubref(row.image)
		if haskey(grouped, trimmed)
			push!(grouped[trimmed], row.image)
		else
			grouped[trimmed] = [row.image]
		end
	end

	mdstrings = []
	for k in keys(grouped)
		thumb = markdownImage(k, iiifsvc(), thumbht)
		params = map(img -> "urn=" * img.urn * "&", grouped[k]) 
		lnk = ict() * join(params,"") 
		push!(mdstrings, "[$(thumb)]($(lnk))")
		
	end
	join(mdstrings, " ")

end

# ╔═╡ 6c24a126-7b5d-11eb-07eb-6f437bbc869a
# Format HTML for EditingRepository's reporting on cataloging status.
function catalogcheck(editorsrepo::EditingRepository)
	cites = citation_df(editorsrepo)
	if filesmatch(editorsrepo, cites)
		md"✅XML files in repository match catalog entries."
	else
		htmlstrings = []
		
		missingfiles = filesonly(editorsrepo, cites)
		if ! isempty(missingfiles)
			fileitems = map(f -> "<li>" * f * "</li>", missingfiles)
			filelist = "<p>Uncataloged files found on disk: </p><ul>" * join(fileitems,"\n") * "</ul>"
			
			hdr = "<div class='warn'><h1>⚠️ Warning</h1>"
			tail = "</div>"
			badfileshtml = join([hdr, filelist, tail],"\n")
			push!(htmlstrings, badfileshtml)
		end
		
		notondisk = citedonly(editorsrepo, cites)
		if ! isempty(notondisk)
			nofilelist = "<p>Configured files not found on disk: </p><ul>" * join(nofiletems, "\n") * "</ul>"
			hdr = "<div class='danger'><h1>🧨🧨 Configuration error 🧨🧨 </h1>" 
			tail = "</div>"
			nofilehtml = join([hdr, nofilelist, tail],"\n")
			push!(htmlstrings,nofilehtml)
		end
		HTML(join(htmlstrings,"\n"))
	end
end

# ╔═╡ ac2d4f3c-7925-11eb-3f8c-957b9de49d88
css = html"""
<style>
.danger {
     background-color: #fbf0f0;
     border-left: solid 4px #db3434;
     line-height: 18px;
     overflow: hidden;
     padding: 15px 60px;
   font-style: normal;
	  }
.warn {
     background-color: 	#ffeeab;
     border-left: solid 4px  black;
     line-height: 18px;
     overflow: hidden;
     padding: 15px 60px;
   font-style: normal;
  }

  .danger h1 {
	color: red;
	}

 .invalid {
	text-decoration-line: underline;
  	text-decoration-style: wavy;
  	text-decoration-color: red;
}
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


.instructions {
     background-color: #f0f7fb;
     border-left: solid 4px  #3498db;
     line-height: 18px;
     overflow: hidden;
     padding: 15px 60px;
   font-style: normal;
  }



</style>
"""

# ╔═╡ 1b381d96-79bf-11eb-2b39-4d510da858f3
md"> Examples"

# ╔═╡ af847106-78f3-11eb-153b-0312f0390fdc
editorsrepo() |> surfacemenu

# ╔═╡ Cell order:
# ╟─3766b28a-79be-11eb-2731-b55581ccd19f
# ╠═d859973a-78f0-11eb-05a4-13dba1f0cb9e
# ╟─1fd65eae-79be-11eb-1599-875ca1d8e6f4
# ╟─7c67cacc-79be-11eb-3fad-fd9950e55117
# ╠═4aacb152-79b2-11eb-349a-cfe86f526399
# ╟─a85774e6-79b9-11eb-1fc8-030922c3d600
# ╟─9d9b8144-79b8-11eb-2545-573129e6b22b
# ╟─54a24382-78f1-11eb-24c8-198fc54ef67e
# ╟─cc19dac4-78f6-11eb-2269-453e2b1664fd
# ╟─d1969604-78f6-11eb-3231-1570919758aa
# ╟─f2f717e2-79b9-11eb-2868-1d7dd6157b38
# ╠═fbfd4d66-79b9-11eb-2022-b73a3729367c
# ╠═0384f280-79ba-11eb-253b-07208c459884
# ╠═060202ca-79ba-11eb-0e42-bdaf0f165118
# ╟─fbd9d710-79ba-11eb-2c14-4d479ee0bbfd
# ╟─d10a6d0a-79b9-11eb-3a98-a95112fa0f3b
# ╟─7f130fb6-78f1-11eb-3143-a7208d3a9559
# ╟─e45a445c-78f1-11eb-3ef5-81b1b7adec63
# ╟─1829efee-78f2-11eb-06bd-ddad8fb26622
# ╟─85119632-7903-11eb-3291-078d8c56087c
# ╟─5c472d86-78f2-11eb-2ead-5196f07a5869
# ╟─81656522-7903-11eb-2ed7-53a05f05ebd6
# ╟─b30ccd06-78f2-11eb-2b03-8bff7ab09aa6
# ╟─202e654e-79ba-11eb-2836-efb2152d7096
# ╠═24fc269c-79ba-11eb-052f-8b45ca87b55c
# ╠═460bce32-79ba-11eb-09de-7bb98dc9127b
# ╠═57c4528e-79ba-11eb-0b2e-e11240803f48
# ╠═711b6876-79ba-11eb-0882-815f8c4d0000
# ╠═9e9db4f2-79ba-11eb-0ec5-35c7d95dcdca
# ╠═a2efcc70-79ba-11eb-0e1d-dddac9e39f26
# ╟─dc194b30-79b9-11eb-3fe8-7fc1930bd1b9
# ╟─dc63a172-79bd-11eb-11cc-0be16699050f
# ╟─58cdfb8e-78f3-11eb-2adb-7518ff306e2a
# ╟─37e5ea20-78f4-11eb-1dff-c36418158c7c
# ╟─36599fea-7902-11eb-2524-3bd9026f017c
# ╟─e4ad8aa0-79bd-11eb-34e9-ab87b28f3654
# ╠═00d8bd66-79bf-11eb-1c5e-677cff39c0d1
# ╟─eb5549ba-79bd-11eb-11bf-f3988bc74b5d
# ╟─f65ca3c6-79bd-11eb-2ced-77d6774b4ca7
# ╟─a1c93e66-78f3-11eb-2ffc-3f5becceedc8
# ╟─283df9ae-7904-11eb-1b77-b74be19a859c
# ╟─442b37f6-791a-11eb-16b7-536a71aee034
# ╟─06d139d4-78f5-11eb-0247-df4126777208
# ╟─0150956a-78f8-11eb-3ebd-793eefb046cb
# ╟─6c24a126-7b5d-11eb-07eb-6f437bbc869a
# ╟─ac2d4f3c-7925-11eb-3f8c-957b9de49d88
# ╟─1b381d96-79bf-11eb-2b39-4d510da858f3
# ╠═af847106-78f3-11eb-153b-0312f0390fdc