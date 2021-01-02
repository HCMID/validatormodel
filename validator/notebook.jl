### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 8e3f7536-4d0b-11eb-13dc-c786ef06e27b
begin
	using Pkg
	Pkg.add("PlutoUI")
end


# ╔═╡ 5c5d9426-4d0b-11eb-2eee-d11655453f29
md"# MID validator notebook"

# ╔═╡ aa8baa16-4d0b-11eb-2cf9-9340f9fcc962
begin
	msg = "<p class='hilite'>Using data in <b>" * pwd() * "</b>"
	HTML(msg)
end

# ╔═╡ 72ae34b0-4d0b-11eb-2aa2-5121099491db
md"## Configuration"

# ╔═╡ 7da35330-4d0b-11eb-3487-81d04b9d1f4a


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

# ╔═╡ Cell order:
# ╟─5c5d9426-4d0b-11eb-2eee-d11655453f29
# ╟─aa8baa16-4d0b-11eb-2cf9-9340f9fcc962
# ╟─72ae34b0-4d0b-11eb-2aa2-5121099491db
# ╠═7da35330-4d0b-11eb-3487-81d04b9d1f4a
# ╟─83083c48-4d0b-11eb-10ee-15323c58e479
# ╠═8e3f7536-4d0b-11eb-13dc-c786ef06e27b
# ╟─0545e9ee-4d0c-11eb-2e3e-7753da1e02f7
# ╟─0fea289c-4d0c-11eb-0eda-f767b124aa57
