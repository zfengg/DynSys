using CairoMakie
let
    odeSol(x,y) = Point(-x, 2y) # x'(t) = -x, y'(t) = 2y
    fig = Figure(resolution = (700, 450), fontsize = 18, font = "sans")
    ax = Axis(fig, xlabel = "x", ylabel = "y", backgroundcolor = :black)
    stplt = streamplot!(ax, odeSol, -2..4, -2..2, colormap = Reverse(:plasma),
        gridsize= (32,32), arrow_size = 10)
    fig[1, 1] = ax
    display(fig)
end
