using InteractiveDynamics, GLMakie, DynamicalSystems
# tent map
# eom
tent_rule(x, p, n) = 3/2 * (1 - abs(2*x - 1))
# jacobian
tent_jac(x, p, n) = sign(0.5 - x) * 3.0
# ds
ds = DiscreteDynamicalSystem(tent_rule, 0.231, [1], tent_jac)

# create cobweb
interactive_cobweb(ds, [1])