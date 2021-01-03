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

# ╔═╡ 8e3f7536-4d0b-11eb-13dc-c786ef06e27b
begin
	using Pkg
	Pkg.add("PlutoUI")
	Pkg.add("CitableText")
end


# ╔═╡ db6cad90-4d0d-11eb-28ad-e16c43bec2c6
using PlutoUI, CitableText

# ╔═╡ 5c5d9426-4d0b-11eb-2eee-d11655453f29
md"# MID validator notebook"

# ╔═╡ 1afc652c-4d13-11eb-1488-0bd8c3f60414
md"## Summary of contents"

# ╔═╡ 142e0644-4d13-11eb-3b89-c17cf5611ad3
md"## Validation results"

# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
md"""## Configuration

### Directory organization
"""

# ╔═╡ 527f86ea-4d0f-11eb-1440-293fc241c198
md"""
Repository root: 
$(@bind reporoot TextField((50,1)); default=pwd())
"""

# ╔═╡ 7da35330-4d0b-11eb-3487-81d04b9d1f4a
md"""Subdirectory for XML editions:
$(@bind editions TextField(default="editions"))
"""

# ╔═╡ 97afc2a2-4d0f-11eb-3869-8ff78542ee6b
md"""Subdirectory for DSE tables:
$(@bind dsedir TextField(default="dse"))
"""

# ╔═╡ 83083c48-4d0b-11eb-10ee-15323c58e479
md"""---
The cells in this block import required code libraries.
"""

# ╔═╡ 50c8bdb4-4d12-11eb-262d-73b0553b6364
md"""
---

Organizing contents
"""

# ╔═╡ af505654-4d11-11eb-07a0-efd94c6ff985
xmleditions = begin
	filter(f -> endswith(f, "xml"), readdir(reporoot * editions))
end

# ╔═╡ 86f739ee-4d12-11eb-28bf-85a424c369e7
editionslist = begin
	items = map(ed -> "<li>" * ed * "</li>", xmleditions)
	HTML("<p>Your editions:</p><ul>" * join(items, "\n") * "</ul>")
end

# ╔═╡ e8a5ddb0-4d0d-11eb-39c5-01602f517042
editionslist

# ╔═╡ 0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
md"""
---
Formatting
"""

# ╔═╡ 0fea289c-4d0c-11eb-0eda-f767b124aa57
css = html"""
<style>
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

# ╔═╡ 53dd4ae6-4d0e-11eb-1ac4-d77658c5b3d3
begin
	msg = "<p class='note'>Using <b>" * reporoot * "</b> as repository's root directory.</p>"
	HTML(msg)
end

# ╔═╡ 8e3ac1a8-4d33-11eb-15fc-d7ace694d1a7
md"""
---

### Prototypes

structs and functions here should be moved into public packages once they've been added to the Julia Registry.

"""

# ╔═╡ afb1cde0-4d33-11eb-2aa0-e9c5d0c4c5e6
struct CitationConfig
	urn::CtsUrn
	filename
	ctparser
end

# ╔═╡ e3371418-4d33-11eb-3cd0-ed52600e1850
function fromcex(s::AbstractString) #, delimiter = "|")
	delimiter = "|"
	parts = split(s,delimiter)
	if size(parts,1) != 3
		throw(ArgumentError("Invalid CEX string $(s).  Should have 3 columns"))
	else
		try
			ctsu = CtsUrn(parts[1])
			fnctn = Meta.parse(parts[3])
			CitationConfig(ctsu, parts[2], fnctn)
		catch e
			throw(e)
		end
	end
	

end

# ╔═╡ 37b53fac-4d56-11eb-0151-9d792d546365
fromcex("urn|citation.cex|print")

# ╔═╡ Cell order:
# ╟─5c5d9426-4d0b-11eb-2eee-d11655453f29
# ╟─1afc652c-4d13-11eb-1488-0bd8c3f60414
# ╟─e8a5ddb0-4d0d-11eb-39c5-01602f517042
# ╟─142e0644-4d13-11eb-3b89-c17cf5611ad3
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─97afc2a2-4d0f-11eb-3869-8ff78542ee6b
# ╟─83083c48-4d0b-11eb-10ee-15323c58e479
# ╠═8e3f7536-4d0b-11eb-13dc-c786ef06e27b
# ╠═db6cad90-4d0d-11eb-28ad-e16c43bec2c6
# ╟─50c8bdb4-4d12-11eb-262d-73b0553b6364
# ╟─af505654-4d11-11eb-07a0-efd94c6ff985
# ╟─86f739ee-4d12-11eb-28bf-85a424c369e7
# ╟─0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─53dd4ae6-4d0e-11eb-1ac4-d77658c5b3d3
# ╟─8e3ac1a8-4d33-11eb-15fc-d7ace694d1a7
# ╠═afb1cde0-4d33-11eb-2aa0-e9c5d0c4c5e6
# ╠═e3371418-4d33-11eb-3cd0-ed52600e1850
# ╠═37b53fac-4d56-11eb-0151-9d792d546365
