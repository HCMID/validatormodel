### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ c5c75bae-4fa2-11eb-1ef7-cf6697380451
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

# ╔═╡ df59fe5c-4fa2-11eb-27ed-bb64ea8cb7d2
reporoot = dirname(pwd())

# ╔═╡ Cell order:
# ╠═c5c75bae-4fa2-11eb-1ef7-cf6697380451
# ╠═df59fe5c-4fa2-11eb-27ed-bb64ea8cb7d2
