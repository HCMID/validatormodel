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
	using PlutoUI
	using CitableText
	using CSV
	using HTTP
end

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
reporoot = dirname(pwd())

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

# ╔═╡ Cell order:
# ╟─9b7d76ac-4faf-11eb-17de-69db047d5f91
# ╟─5c5d9426-4d0b-11eb-2eee-d11655453f29
# ╟─1afc652c-4d13-11eb-1488-0bd8c3f60414
# ╟─e8a5ddb0-4d0d-11eb-39c5-01602f517042
# ╟─142e0644-4d13-11eb-3b89-c17cf5611ad3
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─97afc2a2-4d0f-11eb-3869-8ff78542ee6b
# ╟─50c8bdb4-4d12-11eb-262d-73b0553b6364
# ╟─af505654-4d11-11eb-07a0-efd94c6ff985
# ╟─86f739ee-4d12-11eb-28bf-85a424c369e7
# ╟─0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─53dd4ae6-4d0e-11eb-1ac4-d77658c5b3d3
