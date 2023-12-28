# POMPDPSolve.jl

This is a Julia wrapper for the POMDP-Solve program, orginally developed at Brown University that uses the [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) interface. This package uses the [POMDPSolve_jll](https://github.com/JuliaBinaryWrappers/POMDPSolve_jll.jl) package, which was build using modifications from the code available from Tony Cassandra's [pomdp.org page](http://www.pomdp.org/code/index.html). The modfications are available in the [JuliaPOMDP fork of pomdp-solve](https://github.com/JuliaPOMDP/pomdp-solve).

The pomdp-solve program solves partially observable Markov decision processes (POMDPs), taking a model specification and producing a value function and action policy.  It employs many different algorithms, some exact and some approximate.

Parameters and parameter options are documented in the [`POMDPSolveSolver`](@ref) docstring. If the information cannot be found there, please refer to the JuliaPOMDP fork of pomdp-solve or the original pomdp-solve documentation.

## Installation
You can use the Julia package manager to install POMDPSolve.jl:

```julia
using Pkg
Pkg.add("POMDPSolve")
```

## Example

```julia
using POMDPSolve
using POMDPModels # for TigerPOMDP
pomdp = TigerPOMDP()
solver = POMDPSolveSolver()
policy = solve(solver, pomdp) # returns an AlphaVectorPolicy
```

## Index

```@index
```