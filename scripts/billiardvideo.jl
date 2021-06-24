using InteractiveDynamics, DynamicalBilliards, GLMakie

psize = 2.0

bd = billiard_stadium(1.0f0, 1.0f0) # must be type Float32

frames = 1800
dt = 0.0001
speed = 200
f(p) = p.pos[2] # the function that obtains the data from the particle
total_span = 10.0

ps = particlebeam(1.0, 0.8, 0, 2, 0.0001, nothing, Float32)
ylim = (0, 1)
ylabel = "y"

billiard_video_timeseries(
	datadir("timeseries.mp4"), bd, ps, f;
	displayfigure = true, total_span,
	frames, backgroundcolor = :black,
	plot_particles = true, tailwidth = 4, particle_size = psize, res = (1280, 720),
	dt, speed, tail = 20000, # this makes ultra fine temporal resolution
	framerate = 60, ylabel
)
