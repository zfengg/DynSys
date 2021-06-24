using DynamicalBilliards, InteractiveDynamics, GLMakie

bd, = billiard_logo(T = Float32)
interactive_billiard(bd, 1f0, tail = 1000)
