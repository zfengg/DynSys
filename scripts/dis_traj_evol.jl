using InteractiveDynamics
using DynamicalSystems, GLMakie

ds = Systems.towel() # 3D chaotic discrete system
u0s = [0.1ones(3) .+ 1e-3rand(3) for _ in 1:3]

figure, obs = interactive_evolution(
    ds, u0s; idxs = SVector(1, 2, 3), tail = 100000,
)
