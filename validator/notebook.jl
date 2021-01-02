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
end


# ╔═╡ db6cad90-4d0d-11eb-28ad-e16c43bec2c6
using PlutoUI

# ╔═╡ 5c5d9426-4d0b-11eb-2eee-d11655453f29
md"# MID validator notebook"

# ╔═╡ e8a5ddb0-4d0d-11eb-39c5-01602f517042


# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
md"## Configuration"

# ╔═╡ 7da35330-4d0b-11eb-3487-81d04b9d1f4a
md"""XML editions are in:
$(@bind editions TextField(default="editions"))
"""

# ╔═╡ 83083c48-4d0b-11eb-10ee-15323c58e479
md"""---
#### Code libraries
"""

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

# ╔═╡ 33f05ce6-4d0e-11eb-206d-35763c8fdd07
# Don't re-execute this cell or you'll
# keep walking up the directory tree!
initroot = begin
	cd("..")
	pwd()
end

# ╔═╡ 527f86ea-4d0f-11eb-1440-293fc241c198
md"""
Repository root: 
$(@bind reporoot TextField(default=initroot))
"""

# ╔═╡ 53dd4ae6-4d0e-11eb-1ac4-d77658c5b3d3
begin
	msg = "<p class='note'>Using <b>" * reporoot * "</b> as repository's root directory.</p>"
	HTML(msg)
end

# ╔═╡ Cell order:
# ╟─5c5d9426-4d0b-11eb-2eee-d11655453f29
# ╠═e8a5ddb0-4d0d-11eb-39c5-01602f517042
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╟─527f86ea-4d0f-11eb-1440-293fc241c198
# ╟─7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─83083c48-4d0b-11eb-10ee-15323c58e479
# ╠═8e3f7536-4d0b-11eb-13dc-c786ef06e27b
# ╠═db6cad90-4d0d-11eb-28ad-e16c43bec2c6
# ╟─0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
# ╟─53dd4ae6-4d0e-11eb-1ac4-d77658c5b3d3
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
# ╟─33f05ce6-4d0e-11eb-206d-35763c8fdd07
