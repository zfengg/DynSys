### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# ╔═╡ f6b2aef0-a254-11eb-06ce-b319584299f1
begin
	using DrWatson
	quickactivate(findproject())
	
	using Pkg
	Pkg.instantiate()
	using PlutoUI
	using DynamicalSystems
	using LabelledArrays
	
end

# ╔═╡ c1f9ee76-491e-4dc1-83ef-926b988efc77
md"# Entropy and dimension"

# ╔═╡ 920e567a-5baa-436a-b004-84cf0740fda5
TableOfContents()

# ╔═╡ dc0bafed-2ef3-48dd-a8fe-007916a48826
with_terminal() do
	Pkg.status()
end

# ╔═╡ 4e58bbea-cb4b-44f1-bb4c-213923293146


# ╔═╡ c414329b-c98b-4c0e-bfb3-6d13ab8e4c27


# ╔═╡ 04e61e8a-231e-49c7-91d6-fb72566dac29


# ╔═╡ Cell order:
# ╟─c1f9ee76-491e-4dc1-83ef-926b988efc77
# ╠═920e567a-5baa-436a-b004-84cf0740fda5
# ╠═f6b2aef0-a254-11eb-06ce-b319584299f1
# ╠═dc0bafed-2ef3-48dd-a8fe-007916a48826
# ╠═4e58bbea-cb4b-44f1-bb4c-213923293146
# ╠═c414329b-c98b-4c0e-bfb3-6d13ab8e4c27
# ╠═04e61e8a-231e-49c7-91d6-fb72566dac29
