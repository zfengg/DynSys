### A Pluto.jl notebook ###
# v0.14.4

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

# ╔═╡ d2f7d8f4-a37c-11eb-1d36-673f2e2c1129
begin
	using DrWatson
	quickactivate(findproject())
	
	using Pkg
	Pkg.instantiate()
	
	using PlutoUI
end

# ╔═╡ 687d118b-4808-4cda-91eb-13bb297170fc
TableOfContents()

# ╔═╡ fb52c08c-7394-4945-a527-55ab33b949b2
varinfo(PlutoUI)

# ╔═╡ 14f60089-27fc-41da-9ad0-359d7a3f57cb
md"# Collection of PlutoUI elements"

# ╔═╡ 44396d0d-5d4a-444f-9cbf-fc4a87a29d78
Show(MIME"image/png"(), read("./tutorials/Youtube_JuliaLang_tutorial/lyapunov.png"))

# ╔═╡ a32ae08a-516a-4274-a4f1-5ec16dca1e91
@bind myColor ColorStringPicker(default="#aabbcc")

# ╔═╡ 9381ace3-98ce-4bb0-8cfe-817bb94d1e46
Show(MIME"text/html"(), """<h3 style="color:$myColor"> Hello I'm myColor </h3>""")

# ╔═╡ 59bf381b-101b-4581-81c5-857787d4177f
myColor

# ╔═╡ 999e59d4-a759-4c1f-9941-e8b25e288b17
@bind myFile_uploads FilePicker()

# ╔═╡ 428aba2b-08df-4817-a998-2ee7d7d91d3c
myFile_uploads

# ╔═╡ 1ed8c4e9-46b2-4218-94c7-60a6e2cd5e96
Show(MIME"image/png"(), myFile_uploads["data"])

# ╔═╡ aa37814c-2737-42e1-8e57-92f3003c217e
# as_png()

# ╔═╡ e02cf054-6296-4c19-bda0-dec5efef7a7b
@bind go Button("Go!")

# ╔═╡ cc915792-454b-4614-a135-800e9eda5623
go

# ╔═╡ 38b81b1d-81ce-435f-b14a-561550e87e55
@bind myPassword PasswordField()

# ╔═╡ 66d46fb1-4cb2-475c-aab3-5d4d8f1edeb4
myPassword

# ╔═╡ 105b1b36-a824-4fcf-899b-843ec552b05c
DownloadButton

# ╔═╡ 0f9d33cf-5e97-4b7a-91d1-5e20827e47c3
myPath = pwd()

# ╔═╡ 7c78b5bf-a76f-42d7-98bf-d41cf2cb294a
basename(myPath)

# ╔═╡ c2eefcca-2950-4acb-88bf-9a70bb8d9b70
dirname(myPath)

# ╔═╡ Cell order:
# ╠═d2f7d8f4-a37c-11eb-1d36-673f2e2c1129
# ╠═687d118b-4808-4cda-91eb-13bb297170fc
# ╠═fb52c08c-7394-4945-a527-55ab33b949b2
# ╟─14f60089-27fc-41da-9ad0-359d7a3f57cb
# ╟─44396d0d-5d4a-444f-9cbf-fc4a87a29d78
# ╠═9381ace3-98ce-4bb0-8cfe-817bb94d1e46
# ╠═a32ae08a-516a-4274-a4f1-5ec16dca1e91
# ╠═59bf381b-101b-4581-81c5-857787d4177f
# ╠═999e59d4-a759-4c1f-9941-e8b25e288b17
# ╠═428aba2b-08df-4817-a998-2ee7d7d91d3c
# ╠═1ed8c4e9-46b2-4218-94c7-60a6e2cd5e96
# ╠═aa37814c-2737-42e1-8e57-92f3003c217e
# ╠═e02cf054-6296-4c19-bda0-dec5efef7a7b
# ╠═cc915792-454b-4614-a135-800e9eda5623
# ╠═38b81b1d-81ce-435f-b14a-561550e87e55
# ╠═66d46fb1-4cb2-475c-aab3-5d4d8f1edeb4
# ╠═105b1b36-a824-4fcf-899b-843ec552b05c
# ╠═0f9d33cf-5e97-4b7a-91d1-5e20827e47c3
# ╠═7c78b5bf-a76f-42d7-98bf-d41cf2cb294a
# ╠═c2eefcca-2950-4acb-88bf-9a70bb8d9b70
