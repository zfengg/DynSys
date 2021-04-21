### A Pluto.jl notebook ###
# v0.14.2

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

# ╔═╡ afcaf632-a1cd-11eb-3356-a5f372c4e13c
# environment setup
begin
	using DrWatson
	quickactivate(findproject())
	
	using Pkg
	Pkg.instantiate()
	
	using PlutoUI
	using ImageIO, ImageShow, PNGFiles # for images
	using BenchmarkTools
	using DynamicalSystems
	using Plots
	using LabelledArrays
	using OrdinaryDiffEq
	
	# pyplot()
end

# ╔═╡ 8306fcca-5e2c-45d4-b77e-cf501dfc6fe9
html"""
<img src="https://raw.githubusercontent.com/zfengg/DynSys/master/notebooks/tutorials/Youtube_JuliaLang_tutorial/map_of_ds.png">
"""

# ╔═╡ cc3c8e12-919f-4d4e-b382-d8182e972d51
md"# DynamicalSystemBase"

# ╔═╡ 931892b0-91a4-482d-9c85-d0387cfe3859
TableOfContents()

# ╔═╡ 41418393-d768-46ba-8e20-8e9fe49832cb
with_terminal() do
	Pkg.status()
end

# ╔═╡ ce8754a0-9f82-4c54-aa0e-2b4b92cc853d
md"
## Equation of motion (discrete)

```math
\begin{aligned}
x_{n+1} &= 1 - ax^2_n+y_n \\
y_{n+1} & = bx_n
\end{aligned}
```

"

# ╔═╡ 9d577247-c2ee-4fe0-b840-58dee0502cb1
h_eom(x, p, t) = SVector{2}(1.0 - p[1] * x[1]^2 + x[2], p[2] * x[1])

# ╔═╡ e1d65fe3-3a40-47bf-88e6-830e79199a83
md"##### Initial state"

# ╔═╡ b7eeb6c7-536f-4a03-a94b-1242f347255d
state = zeros(2)

# ╔═╡ 8d042de2-9200-4d71-b9bc-c852ede2c9cf
md"#### Parameters for the EOM"

# ╔═╡ 681a93a3-d08a-43a6-a061-7b35805f0508
md"### Getting a trajectory

```julia
trajectory(ds::DynamicalSystem, T [, u]; kwargs...)
```
which evolves a system for total time `T`, optionally starting from a different state 
`u`.

"

# ╔═╡ 87d179c3-12a8-48f6-93d2-d8bee2abce5d
md"
x = $(@bind x_cord Slider(0:0.1:2; default=1.4, show_value=true))  $ \quad $
y = $(@bind y_cord Slider(0:0.1:2; default=0.3, show_value=true))
"

# ╔═╡ 52c45448-ca74-465e-97f1-3eedb43e8ae5
p = [x_cord, y_cord] # p = [a, b] from the equation of motion

# ╔═╡ 6a0f261f-5552-4b88-94d5-45e77d879f09
henon = DiscreteDynamicalSystem(h_eom, state, p)

# ╔═╡ cd70f1e7-8dde-495d-831d-57db4d7652d6
# trajectory from initial condition
tr = trajectory(henon, 100000)

# ╔═╡ 42c3fd93-5dc4-49c3-abcb-c3282dc039cf
tr2 = trajectory(henon, 100000, 0.01rand(2))

# ╔═╡ d36135c8-3142-4e92-bcbb-31726073739a
begin
	plotrange = 1000:100000
	scatter(tr[plotrange,1], tr[plotrange,2], 
	markersize=0.1, markeralpha = 0.3, markercolor="black",
	html_output_format=:png, leg=false, title="Hénon attractor", size=(1200, 800))
end

# ╔═╡ b05b744d-64b9-4ab5-b439-9f774684f9fa
md"### Jacobian function"

# ╔═╡ 3ef3cce2-c5af-4f8c-85e1-a996b3d70ba9
henon

# ╔═╡ 4723d3a6-8792-4169-b964-3fc1ec8c3530
h_jacobian(x, p, t) = @SMatrix [-2*p[1]*x[1] 1.0; 
                                p[2]         0.0]

# ╔═╡ d6ac38f4-e7c6-4966-b942-54912da341c3
henon_with_jac = DiscreteDynamicalSystem(h_eom, state, p, h_jacobian)

# ╔═╡ 9b400d98-df9f-4307-99dc-333c014c0e30
md"""
Even though `ForwardDiff` is truly performant, the hard-coded version should "always" be faster. 

!!! tip
	This becomes much more important for higher dimensional systems, especially for the in-place form!
"""

# ╔═╡ 746ab80e-57b5-4842-94bd-cdd3b0a64b58
md"### Using labelled arrays"

# ╔═╡ 071d86b2-aceb-4f96-a8a9-3c33fce48f1c
new_state = SVector{2}(0., 0.)

# ╔═╡ 09f2417f-996e-40f8-9548-9196d81a687d
new_p = SLVector(a=1.4, b=0.3)

# ╔═╡ 0ec7f640-9c32-42bd-9ba0-75061f873072
new_h_eom(x, p, t) = SVector{2}(1 - p.a * x[1]^2 + x[2], p.b * x[1])

# ╔═╡ fb428aa0-3e92-4e1e-bd51-f583312b6ee1
new_h_jac(x, p, t) = @SMatrix [-2* p.a * x[1] 1.0; 
						p.b       0.0]

# ╔═╡ bb33ef3f-6ad8-485d-9941-2322cfbfe6fd
new_henon = DiscreteDynamicalSystem(new_h_eom, new_state, new_p, new_h_jac)

# ╔═╡ 08ebed37-d4d1-4ffa-9a54-75a4a9de36c4
new_tr = trajectory(new_henon, 100000, 0.01rand(2))

# ╔═╡ 1b50fd1b-f0e8-4bf4-b2d5-055b61eae2cd
begin
	# plotrange = 1000:100000
	scatter(new_tr[plotrange,1], new_tr[plotrange,2], 
	markersize=0.1, markeralpha = 0.3, markercolor="black",
	leg=false, title="Hénon attractor", 
	html_output_format=:png, size=(1200,800))
end

# ╔═╡ 7f04a8e8-ff64-4d8f-8557-c151268dc69e
md"## Continuous system (ODE)

* We will take the opportunity to show the process of using in-place equations of motion for a continuous system, which is aimed to be used for large systems (dimensionality $\ge$ 10). In general, in-place is suggested for big systems, whereas out-place is suggested for small systems. The break-even point at around 100 dimensions, and for using functions that use the tangent space (like e.g. `lyapunovs` or `gali`), the break-even point is at around 10 dimensions. See the [document](https://juliadynamics.github.io/DynamicalSystems.jl/latest/ds/general) for details.

* In addition, the system we will use (Henon-Heiles) does not have any parameters.

```math
\begin{aligned}
\dot{x} &= p_x \\
\dot{y} &= p_y \\
\dot{p}_x &= -x -2 xy \\
\dot{p}_y &= -y - (x^2 - y^2)
\end{aligned}
```

"

# ╔═╡ 3bf15b85-fc28-4cd7-8190-2c11ca396436
# Henon-heiles famous system
# in-place form of equations of motion
# du is the derivatives vector, u is the state vector
function hheom!(du, u, p, t)
    du[1] = u[3]
    du[2] = u[4]
    du[3] = -u[1] - 2u[1]*u[2]
    du[4] = -u[2] - (u[1]^2 - u[2]^2)
    return nothing
end

# ╔═╡ 096e8c3d-81ea-44da-be3b-b5fd7710e944
# pass `nothing` as the parameters, because the system doesn't have any
hh = ContinuousDynamicalSystem(hheom!, [0, -0.25, 0.42081, 0], nothing)

# ╔═╡ db719b46-cf67-43a3-b242-db991d8f6470
tr_hh = trajectory(hh, 100.0, dt = 0.05)

# ╔═╡ 5b545dc8-ee16-44ff-b025-aca9ea2add33
begin
	plot(tr_hh[:, 1], tr_hh[:, 2], leg=false)
	scatter!([tr[1, 1]], [tr[1, 2]])	
end

# ╔═╡ 9f9dac92-ffc5-4514-b54e-036fac9825f7
DynamicalSystemsBase.CDS_KWARGS

# ╔═╡ 0b28bd26-0321-4474-a51d-3271a87f593e
md"
It is almost certain that if you use **DynamicalSystems.jl** you want to use also DifferentialEquations.jl, due to the huge list of available features.


### Interface to DifferentialEquations.jl

```julia
ContinuousDynamicalSystem(prob::ODEProblem [, jacobian [, J0]])
ODEProblem(continuous_dynamical_system, tspan [; callback, mass_matrix])
```
"

# ╔═╡ a108c846-90a2-4c2f-999b-6f0cf337ba2f
diffeq = (alg = Tsit5(), rtol = 1e-3, dtmax = 0.01)

# ╔═╡ f7d8ce48-4739-4d00-b745-4387b2706c12
hhtr2 = trajectory(hh, 100.0; diffeq...)

# ╔═╡ 289d9eb1-1fd4-4571-b5d1-9fd12f53d547
plot(hhtr2[:, 1], hhtr2[:, 2], color = :orange, leg=false)

# ╔═╡ 60b16a48-fd3e-48c8-99a7-8efac1a5121a
md"""
# Chaos tools
## 2.A. What to do with a `DynamicalSystem`? Orbit Diagram
An "orbit diagram" is simply a plot that shows the long term behavior of a discrete system when a parameter is varied. 

How does one compute it?
1. Evolves the system for a transient amount of time.
2. Evolves & saves the output of the system for a chosen amount of time.
3. Changes/increments a parameter of the equations of motion.
4. Repeat steps 1-3 for all given parameter values.

This is exactly what the function `orbitdiagram` does!


---

Let's make the super-ultra-famous orbit diagram of the logistic map:

$$x_{n+1} = rx_n(1-x_n)$$
"""

# ╔═╡ 3b63710f-bd84-402f-8fdd-ec19785ec3f7
logimap = Systems.logistic() # Systems module contains pre-defined well-known systems

# ╔═╡ 127824a9-0fe1-4e7f-9d9c-9cbbb0d0c81d
md"""
---

The call signature of `orbitdiagram` is:

```julia
orbitdiagram(discrete_system, i, p_index, pvalues; n, Ttr, ...)
```
* `i` is the index of the variable we want to save (for which variable to create the orbit diagram).
* `p_index` is the index of the parameter of `discrete_system` that we want to change.
* `pvalues` is the collection of the values that the changing parameter would take on.
* Keywords `Ttr` and `n` denote for how much transient time to evolve the system (that is, how many time steps to throw away from the beginning), and how many steps to save.

"""

# ╔═╡ 8e11f719-c56e-493a-8062-66674fd5c1b5
begin
	i = 1
	n = 2000 # how many values to save
	Ttr = 2000 # transient iterations
	p_index = 1
	pvalues = 2:0.001:4  # parameter values
	output = orbitdiagram(logimap, i, p_index, pvalues; n = n, Ttr = Ttr)
	typeof(output)
end

# ╔═╡ 6d0a9cab-c0b9-4997-ba86-1eb37d5b9268
function plot_od(r1, r2, n = 1000, Ttr = 1000)
    params = range(r1, stop = r2, length = 1001)

    res = orbitdiagram(logimap, 1, 1, params; n = n, Ttr = Ttr)
    L = length(params)

    x = Matrix{Float64}(undef, n, L)
    y = Matrix{Float64}(undef, n, L)
    for j in 1:L
        x[:,j] .= params[j]
        y[:,j] .= res[j]
    end
    scatter(x, y,
        markersize=0.1, markeralpha = 0.3, markercolor="black",
        leg=false, title="Bifurcation graph", 
        html_output_format=:png, size=(2000,1000))
end

# ╔═╡ 5d5b6f0c-659e-48d8-a37f-038be0c7b806
plot_od(2, 4.0)

# ╔═╡ d603fe4e-4200-46af-8e53-66c031307826
plot_od(3.5, 3.6)

# ╔═╡ 5305290f-dd1e-48d5-8e90-bf9939f1e516
md"""
!!! note
	`orbitdiagram` works with *any* discrete system! Check out the [documentation page](https://juliadynamics.github.io/DynamicalSystems.jl/latest/chaos/orbitdiagram/) for more!

"""

# ╔═╡ e469e1a6-1b59-4307-b2d9-562bf2a77a34
md"""
## 2.B. Poincaré Surface of Section
This is a technique to reduce a continuous system into a discrete map with 1 fewer dimension.
The wikipedia entry on [Poincaré map](https://en.wikipedia.org/wiki/Poincar%C3%A9_map) has a lot of useful info, but the technique itself is very simple:

1. Define a hyperplane in the phase-space of the system. 
2. Evolve the continuous system for long times. Each time the trajectory crosses this plane, record the state of the system.
3. Only crossings with a specific direction (either positive or negative) are allowed.

And that's it! The recorded crossings are the Poincaré Surface of Section!

### Defining a hyperplane
Let's say that our phase-space is $D$ dimensional. If the state of the system is $\mathbf{u} = (u_1, \ldots, u_D)$ then the equation for a hyperplane is 

```math
a_1u_1 + \dots + a_Du_D = \mathbf{a}\cdot\mathbf{u}=b 
```math
where $\mathbf{a}, b$ are the parameters that define the hyperplane.

---

Here is the call signature for a function that does this:

```julia
poincaresos(continuous_system, plane, tfinal = 100.0; kwargs...)
```
In code, `plane` can be either:

* A `Tuple{Int, <: Number}`, like `(j, r)` : the hyperplane is defined as when the `j`-th variable of the system crosses the value `r`.
* An `AbstractVector` of length `D+1`. The first `D` elements of the vector correspond to $\mathbf{a}$ while the last element is $b$. The hyperplane is defined with its formal equation.

---

As an example, let's see a section of the Lorenz system:
```math
\begin{aligned}
\dot{X} &= \sigma(Y-X) \\
\dot{Y} &= -XZ + \rho X -Y \\
\dot{Z} &= XY - \beta Z
\end{aligned}
```
"""

# ╔═╡ 5c557084-55f9-45bf-ba4c-042b431782ce
lor = Systems.lorenz()

# ╔═╡ 3216310f-b01c-4848-bbfc-e45abfeb8c50
begin
	tr_lor = trajectory(lor, 100.0; dt = 0.005, Ttr = 50.0)
	x, y, z = columns(tr_lor)
	plot(x,y,z,
			leg=false, title="Lorenz attractor", 
			html_output_format=:png, size=(1000,1000))
end

# ╔═╡ a67c55be-cc8a-4209-8cda-6e71e83d215a
md"**First, let's visualize the Poincaré Surface of Section in 3D**"

# ╔═╡ 5109be2e-c87b-473d-aa3a-65c2b3995a2c
begin
	plot(x,y,z, color = :black, lw = 1, alpha = 0.25)
	scatter!(x, y, z, 
			markersize=2, markeralpha = 0.4, markercolor="black",
			leg=false, title="Lorenz attractor", 
			html_output_format=:png, size=(2000,2000))
end

# ╔═╡ 6e4b7c78-177c-4374-b0d1-64248e0bd518
md"""

With the $y=0$ plane, we separate the attractor into for subsets: 
* points in the front, 
* points in the back, 
* points crossing the $y=0$ plane from the front,
* points crossing the $y=0$ plane from the back.

The `poincaresos` (Poincare surface of section) function would automatically find all points crossing the $y=0$ plane from the back to the front, which are drawn black in the following diagram.

"""

# ╔═╡ 4d99107e-6f84-4a1d-93bd-b27ec8c49826
begin
	tr_lor1 = trajectory(lor, 400.0, dt = 0.005, Ttr = 50.0)
	x_lor, y_lor, z_lor = columns(tr_lor1)
	
	black = fill(false, length(y_lor))
	red = fill(false, length(y_lor))
	blue = fill(false, length(y_lor))
	green = fill(false, length(y_lor))
	for i in 1:length(y_lor)-1
	    if y_lor[i] < 0 && y_lor[i+1] > 0
	        black[i] = true
	    elseif y_lor[i] > 0 && y_lor[i+1] < 0
	        red[i] = true
	    elseif y_lor[i] > 0
	        blue[i] = true
	    else
	        green[i] = true
	    end
	end
	
	scatter(x_lor[black], y_lor[black], z_lor[black], 
	        markersize=5, markeralpha = 0.8, markercolor=:black)
	scatter!(x_lor[red], y_lor[red], z_lor[red], 
	        markersize=5, markeralpha = 0.8, markercolor=:red)
	scatter!(x_lor[green], y_lor[green], z_lor[green], 
	        markersize=1, markeralpha = 0.9, markercolor=:green)
	scatter!(x_lor[blue], y_lor[blue], z_lor[blue], 
	        markersize=1, markeralpha = 0.3, markercolor=:blue,
	        leg=false,
	        html_output_format=:png, size=(2000,1600), camera = (0,0))
end

# ╔═╡ b9e30b99-9061-48cf-9598-d71a25cd1ab9
md"**Now let's use the `poincaresos` function**"

# ╔═╡ 1f7ea805-8c0c-4bdc-a581-20e336718668
plane = (2, 0.0) # when 2nd variable crosses 0.0

# ╔═╡ 00db6a02-6acf-40f0-89b5-50dafd8cf1cc
psos_chaotic = poincaresos(lor, plane, 2000.0, Ttr = 100.0)

# ╔═╡ 26a177d7-8b4c-42a1-bc76-f1d791d19205
scatter(psos_chaotic[:, 1], psos_chaotic[:, 3],
        markersize=0.15, markeralpha = 0.15, markercolor=:black,
        leg=false, title="Lorenz attractor Poincare section", 
        html_output_format=:png, size=(500,500))

# ╔═╡ ddf6ad5e-ed70-4564-9c17-aefc749cb4ef
md"""
* We see that the surface of section is some kind of 1-dimensional object. 
* This is expected, because as we will show in the tutorial "Entropies & Dimensions" the Lorenz system (at least for the default parameters) lives in an almost 2-dimensional attractor.

* This means that when you take a cut through this object, the result should be 1-dimensional!
"""

# ╔═╡ 4c21df4e-57d4-4af6-beb8-f123b50fef41
md"Let's now compute the PSOS for a parameter value where the Lorenz system is stable instead of chaotic:"

# ╔═╡ 4e0108af-29c6-4445-b565-084aeb82368e
set_parameter!(lor, 2, 69.75)

# ╔═╡ 5a5e4f09-19df-48d5-92ff-a16f6476b43f
begin
	tr_lor2 = trajectory(lor, 100.0, dt = 0.01, Ttr = 500.0)
	x_lor2, y_lor2, z_lor2 = columns(tr_lor2)
	red2 = -0.1 .< y_lor2 .< 0.1
	blue2 = y_lor2 .≤ -0.1
	green2 = y_lor2 .≥ 0.1;

	scatter(x_lor2[red2], y_lor2[red2], z_lor2[red2], 
			markersize=3, markeralpha = 0.8, markercolor=:red)
	scatter!(x_lor2[green2], y_lor2[green2], z_lor2[green2], 
			markersize=1, markeralpha = 0.3, markercolor=:green)
	scatter!(x_lor2[blue2], y_lor2[blue2], z_lor2[blue2], 
			markersize=1, markeralpha = 0.8, markercolor=:blue,
			leg=false, title="Lorenz attractor", 
			html_output_format=:png, size=(700,500), camera = (0,0))
end

# ╔═╡ 94ab5d9d-8c17-49ed-b9f6-43ce2cea5839
begin
	psos_regular = poincaresos(lor, (2, 0.0), 2000.0, Ttr = 1000.0)
	summary(psos_regular)
end

# ╔═╡ faac5d89-5edf-41e7-b598-258ee92377b3
scatter(psos_regular[:, 1], psos_regular[:, 3],
        markersize=0.15, markeralpha = 0.15, markercolor=:black,
        leg=false, title="Non-chaotic Lorenz attractor Poincare section", 
        html_output_format=:png, size=(500,500))

# ╔═╡ 3675071c-d0cf-4b66-97b0-d3577c6e0c8e
md"And here are the two different PSOS plots side by side:"

# ╔═╡ 82bebf58-638b-4c54-ba62-4c6a58087419
begin
	p1 = scatter(psos_chaotic[:, 1], psos_chaotic[:, 3],
			markersize=0.15, markeralpha = 0.15, markercolor=:black,
			leg=false, title="chaotic", 
			html_output_format=:png)

	p2 = scatter(psos_regular[:, 1], psos_regular[:, 3],
			markersize=0.15, markeralpha = 0.15, markercolor=:black,
			leg=false, title="nonchaotic", 
			html_output_format=:png)

	plot(p1,p2,layout=(1,2),legend=false, size=(1000,500))
end

# ╔═╡ ff4e8b82-9167-4c66-b2e8-c6e3bd2e66da
md"""

Lyapunov exponents measure the exponential separation rate of trajectories that are (initially) close. 

Consider the following picture, where two nearby trajectories are evolved in time:
 


![Sketch of the Lyapunov exponent](https://raw.githubusercontent.com/zfengg/DynSys/master/notebooks/tutorials/Youtube_JuliaLang_tutorial/lyapunov.png)

* $\lambda$ denotes the "maximum Lyapunov exponent".
* A $D$-dimensional system has $D$ exponents.
* In general, a trajectory is called "chaotic" if
    1. it follows nonlinear dynamics
    2. it is *bounded* (does not escape to infinity)
    2. it has at least one positive Lyapunov exponent

*(please be aware that the above is an over-simplification! See the textbooks cited in our documentation for more)*

---

"""

# ╔═╡ e1efd072-9940-4698-b08a-0a9c122122ad
md"""
### Demonstration
Before computing Lyapunov exponents, we'll demonstrate the concept of exponential separation using the Henon map that we used before

```math
\begin{aligned}
x_{n+1} &= 1 - ax_n^2 + y_n \\
y_{n+1} &= bx_n
\end{aligned}
```

"""

# ╔═╡ c12d0bbe-f302-4095-9ab6-5de656e94912
df_henon = Systems.henon()

# ╔═╡ 2451e093-ae7a-432d-bac1-3a73225747af
md"First we'll generate a trajectory for the towel map, `tr1`, from the default initial condition,"

# ╔═╡ 0ea6724d-9661-4c46-8e24-9d8a1d34df0e
begin
	df_tr1 = trajectory(df_henon, 100)
	summary(df_tr1)
end

# ╔═╡ 1209f14c-7a58-4431-971d-b3dd2d2807f8
begin
	u2 = get_state(df_henon) + (1e-9 * ones(dimension(df_henon)) )
	df_tr2 = trajectory(df_henon, 100, u2)
	summary(df_tr2)
end

# ╔═╡ 819f4c85-7b9a-499e-a57e-30569873020e
md"""
### Computing the Lyapunov Exponents

`lyapunov` is a function that calculates the maximum Lyapunov exponent for a DynamicalSystem (for a given starting point).
"""

# ╔═╡ b335c3ed-ea1f-4751-995c-0d780767888b
λ = lyapunov(henon, 5000) # second argument is time to evolve 

# ╔═╡ aa533bf7-0f73-4697-897a-36ecf7a32cf5
begin
	using LinearAlgebra: norm
	
	# Plot the x-coordinate of the two trajectories:
	p1_dfhenon = plot(df_tr1[:, 1], alpha = 0.5, title="Diverging trajectories")
	plot!(df_tr2[:, 1], alpha = 0.5)

	# Plot their distance in a semilog plot:
	dist_tr12 = [norm(df_tr1[i] - df_tr2[i]) for i in 1:length(df_tr2)]
	p2_dfhenon = plot(dist_tr12, yaxis=:log, title="Their distance")
	plot!(collect(0:50), dist_tr12[1] .* exp.(collect(0:50) .* λ))

	plot(p1_dfhenon, p2_dfhenon, layout=(2,1), legend=false)

end


# ╔═╡ df6a2bd4-e479-4c8d-bc00-fe3e869491c1
md"""
!!! note
	This number is _approximately_ the slope of the distance increase!

"""

# ╔═╡ 8c0ec462-7a90-47b0-b133-a86553780101
md"If you want to get more than one Lyapunov exponents of a system, use `lyapunovs`"

# ╔═╡ f3e77554-8864-49b4-bb3d-a9354a8e07fc
lyapunovs(henon, 2000)

# ╔═╡ 6750baaa-4809-4fb0-94c0-640323ba500d
md"""
### Continuous systems

* All functions that accept a `DynamicalSystem` work with *any* instance of `DynamicalSystem`, regardless of whether it is continuous, discrete, in-place, out-of-place, with Jacobian or whatever.
* `lyapunov` and `lyapunovs` both accept a `DynamicalSystem`.

This means that they will "just work" if we use the Lorenz system, `lor`.

"""

# ╔═╡ 206478fd-c79d-4782-82ae-139b39777ca2
begin
	df_lor = Systems.lorenz()
	lyapunov(df_lor, 2000.0)
end

# ╔═╡ 7a06d829-d8e5-4a15-a4cf-fb038ee65b0c
lyapunovs(df_lor, 2000)

# ╔═╡ fd68e409-9a35-4821-830a-fdce468c82b0
md"""
!!! note "Recall"
	Remember from the Poincare section that for some parameter values the Lorenz system was periodic, for others it was not.
"""

# ╔═╡ b8dd638c-ebc4-447e-b861-6c845c53f84a
begin
ρs = (69.75, 28.0)
p11 = []
c = ["red", "blue"]
for (i, ρ) in enumerate(ρs)
    set_parameter!(df_lor, 2, ρ)
    psos1 = poincaresos(lor, (2, 0.0), 2000.0, Ttr = 2000.0)
    pi = scatter(psos1[:, 1], psos1[:, 3],
        markersize=0.15, markeralpha = 0.15, markercolor=c[i], 
        title=string("\\rho", " = $ρ, ", (i != 1 ? "not periodic" : "periodic")))
    push!(p11, pi)
end

plot(p11[1],p11[2], layout=(1,2), legend=false, size=(1000,500))
end

# ╔═╡ 8ca3c940-c26d-495b-9eaf-824fa7cf9930
md"Seems like the exponent in the first case λ should be equal to zero, and in the second λ should be positive."

# ╔═╡ 52aec3a6-1cb1-44f9-8db5-c997f9cd1ca9
begin
	ρs1 = (69.75, 28.0)
	
	for (i, ρ) in enumerate(ρs1)
	    set_parameter!(df_lor, 2, ρ)
	    λ = lyapunov(df_lor, 2000.0; Ttr = 2000.0)
	    println("For ρ = $ρ, λ = $λ")
	end
end

# ╔═╡ 8ea8a511-50e4-4270-bd53-dcf17e572318
md"""
One has to be **very careful** when using functions like `lyapunovs`. They are approximative methods! Naively doing short computations or not using large transient times can lead to wrong results!
"""

# ╔═╡ 7ab73182-0dde-4897-979a-d08212533b69
md"""
### Benchmarks

The Lyapunov exponent computations are quite fast! To benchmark them we can use the `BenchmarkTools` package.

!!! danger "Warning"
	Check the latest documentation of `lyapunov`

"""

# ╔═╡ 71f9241b-7817-4006-bd0f-b8fee0f03f5e
diffeq1 = (reltol = 1e-6, abstol = 1e-6) 

# ╔═╡ 4e4939c8-c571-4a13-89de-bba51b8d2cda
@btime lyapunovs(df_lor, 2000; Ttr = 200, $diffeq1...) # use default solver SimpleATsit5()

# ╔═╡ 0edd455c-4b15-4ee5-b395-e35e7d778064
@btime lyapunovs(df_lor, 2000; Ttr = 200, $diffeq..., alg = Vern9())

# ╔═╡ 7e70c6e4-56f0-4cb9-a29d-d2e1b0dec3d5
tow = Systems.towel() # 3D discrete chaotic system

# ╔═╡ 2d8fa5a8-1186-4a4f-ac4b-d2aa38af02d7
@btime lyapunovs(tow, 2000; Ttr = 200)

# ╔═╡ Cell order:
# ╟─8306fcca-5e2c-45d4-b77e-cf501dfc6fe9
# ╟─cc3c8e12-919f-4d4e-b382-d8182e972d51
# ╠═afcaf632-a1cd-11eb-3356-a5f372c4e13c
# ╠═931892b0-91a4-482d-9c85-d0387cfe3859
# ╠═41418393-d768-46ba-8e20-8e9fe49832cb
# ╠═ce8754a0-9f82-4c54-aa0e-2b4b92cc853d
# ╠═9d577247-c2ee-4fe0-b840-58dee0502cb1
# ╟─e1d65fe3-3a40-47bf-88e6-830e79199a83
# ╠═b7eeb6c7-536f-4a03-a94b-1242f347255d
# ╟─8d042de2-9200-4d71-b9bc-c852ede2c9cf
# ╟─52c45448-ca74-465e-97f1-3eedb43e8ae5
# ╠═6a0f261f-5552-4b88-94d5-45e77d879f09
# ╟─681a93a3-d08a-43a6-a061-7b35805f0508
# ╠═cd70f1e7-8dde-495d-831d-57db4d7652d6
# ╠═42c3fd93-5dc4-49c3-abcb-c3282dc039cf
# ╟─87d179c3-12a8-48f6-93d2-d8bee2abce5d
# ╠═d36135c8-3142-4e92-bcbb-31726073739a
# ╟─b05b744d-64b9-4ab5-b439-9f774684f9fa
# ╠═3ef3cce2-c5af-4f8c-85e1-a996b3d70ba9
# ╠═4723d3a6-8792-4169-b964-3fc1ec8c3530
# ╠═d6ac38f4-e7c6-4966-b942-54912da341c3
# ╟─9b400d98-df9f-4307-99dc-333c014c0e30
# ╟─746ab80e-57b5-4842-94bd-cdd3b0a64b58
# ╠═071d86b2-aceb-4f96-a8a9-3c33fce48f1c
# ╠═09f2417f-996e-40f8-9548-9196d81a687d
# ╠═0ec7f640-9c32-42bd-9ba0-75061f873072
# ╠═fb428aa0-3e92-4e1e-bd51-f583312b6ee1
# ╠═bb33ef3f-6ad8-485d-9941-2322cfbfe6fd
# ╠═08ebed37-d4d1-4ffa-9a54-75a4a9de36c4
# ╠═1b50fd1b-f0e8-4bf4-b2d5-055b61eae2cd
# ╟─7f04a8e8-ff64-4d8f-8557-c151268dc69e
# ╠═3bf15b85-fc28-4cd7-8190-2c11ca396436
# ╠═096e8c3d-81ea-44da-be3b-b5fd7710e944
# ╠═db719b46-cf67-43a3-b242-db991d8f6470
# ╠═5b545dc8-ee16-44ff-b025-aca9ea2add33
# ╠═9f9dac92-ffc5-4514-b54e-036fac9825f7
# ╟─0b28bd26-0321-4474-a51d-3271a87f593e
# ╠═a108c846-90a2-4c2f-999b-6f0cf337ba2f
# ╠═f7d8ce48-4739-4d00-b745-4387b2706c12
# ╠═289d9eb1-1fd4-4571-b5d1-9fd12f53d547
# ╟─60b16a48-fd3e-48c8-99a7-8efac1a5121a
# ╠═3b63710f-bd84-402f-8fdd-ec19785ec3f7
# ╟─127824a9-0fe1-4e7f-9d9c-9cbbb0d0c81d
# ╠═8e11f719-c56e-493a-8062-66674fd5c1b5
# ╠═6d0a9cab-c0b9-4997-ba86-1eb37d5b9268
# ╠═5d5b6f0c-659e-48d8-a37f-038be0c7b806
# ╠═d603fe4e-4200-46af-8e53-66c031307826
# ╟─5305290f-dd1e-48d5-8e90-bf9939f1e516
# ╟─e469e1a6-1b59-4307-b2d9-562bf2a77a34
# ╠═5c557084-55f9-45bf-ba4c-042b431782ce
# ╠═3216310f-b01c-4848-bbfc-e45abfeb8c50
# ╟─a67c55be-cc8a-4209-8cda-6e71e83d215a
# ╠═5109be2e-c87b-473d-aa3a-65c2b3995a2c
# ╟─6e4b7c78-177c-4374-b0d1-64248e0bd518
# ╠═4d99107e-6f84-4a1d-93bd-b27ec8c49826
# ╟─b9e30b99-9061-48cf-9598-d71a25cd1ab9
# ╠═1f7ea805-8c0c-4bdc-a581-20e336718668
# ╠═00db6a02-6acf-40f0-89b5-50dafd8cf1cc
# ╠═26a177d7-8b4c-42a1-bc76-f1d791d19205
# ╟─ddf6ad5e-ed70-4564-9c17-aefc749cb4ef
# ╟─4c21df4e-57d4-4af6-beb8-f123b50fef41
# ╠═4e0108af-29c6-4445-b565-084aeb82368e
# ╠═5a5e4f09-19df-48d5-92ff-a16f6476b43f
# ╠═94ab5d9d-8c17-49ed-b9f6-43ce2cea5839
# ╠═faac5d89-5edf-41e7-b598-258ee92377b3
# ╟─3675071c-d0cf-4b66-97b0-d3577c6e0c8e
# ╠═82bebf58-638b-4c54-ba62-4c6a58087419
# ╟─ff4e8b82-9167-4c66-b2e8-c6e3bd2e66da
# ╟─e1efd072-9940-4698-b08a-0a9c122122ad
# ╠═c12d0bbe-f302-4095-9ab6-5de656e94912
# ╟─2451e093-ae7a-432d-bac1-3a73225747af
# ╠═0ea6724d-9661-4c46-8e24-9d8a1d34df0e
# ╠═1209f14c-7a58-4431-971d-b3dd2d2807f8
# ╟─aa533bf7-0f73-4697-897a-36ecf7a32cf5
# ╟─819f4c85-7b9a-499e-a57e-30569873020e
# ╠═b335c3ed-ea1f-4751-995c-0d780767888b
# ╟─df6a2bd4-e479-4c8d-bc00-fe3e869491c1
# ╟─8c0ec462-7a90-47b0-b133-a86553780101
# ╠═f3e77554-8864-49b4-bb3d-a9354a8e07fc
# ╟─6750baaa-4809-4fb0-94c0-640323ba500d
# ╠═206478fd-c79d-4782-82ae-139b39777ca2
# ╠═7a06d829-d8e5-4a15-a4cf-fb038ee65b0c
# ╟─fd68e409-9a35-4821-830a-fdce468c82b0
# ╠═b8dd638c-ebc4-447e-b861-6c845c53f84a
# ╟─8ca3c940-c26d-495b-9eaf-824fa7cf9930
# ╠═52aec3a6-1cb1-44f9-8db5-c997f9cd1ca9
# ╟─8ea8a511-50e4-4270-bd53-dcf17e572318
# ╟─7ab73182-0dde-4897-979a-d08212533b69
# ╠═71f9241b-7817-4006-bd0f-b8fee0f03f5e
# ╠═4e4939c8-c571-4a13-89de-bba51b8d2cda
# ╠═0edd455c-4b15-4ee5-b395-e35e7d778064
# ╠═7e70c6e4-56f0-4cb9-a29d-d2e1b0dec3d5
# ╠═2d8fa5a8-1186-4a4f-ac4b-d2aa38af02d7
