using InteractiveDynamics, GLMakie, DynamicalSystems
# b-adic expansion
# eom
badic_rule(x, b, n) = mod(b[1] * x, 1)
# jacobian
badic_jac(x, b, n) = b[1]
# ds
ds = DiscreteDynamicalSystem(badic_rule, 0.1, [3], badic_jac)

# coweb
brange = 2:10
interactive_cobweb(ds, collect(brange), 1; pname = "b")