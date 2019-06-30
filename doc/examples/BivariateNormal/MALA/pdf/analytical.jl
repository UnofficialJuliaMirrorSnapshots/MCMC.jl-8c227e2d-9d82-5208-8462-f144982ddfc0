using Distributions, Klara

distribution = MvNormal([0., 0.], [1. 0.8; 0.8 1.])

p = BasicContMuvParameter(
  :p,
  logtarget=x::Vector{Float64} -> logpdf(distribution, x),
  gradlogtarget=x::Vector{Float64} -> gradlogpdf(distribution, x)
)

model = likelihood_model([p], isindexed=false)

mcsampler = MALA(0.3)

tuner = VanillaMCTuner()

mcrange = BasicMCRange(nsteps=10000, burnin=1000)

v0 = Dict(:p=>Float64[1.25, 3.11])

outopts = Dict(:monitor=>[:value, :logtarget, :gradlogtarget], :diagnostics=>[:accept])

job = BasicMCJob(model, mcsampler, mcrange, v0, outopts=outopts)

@time run(job)

chain = output(job)

mean(chain)

acceptance(chain)
