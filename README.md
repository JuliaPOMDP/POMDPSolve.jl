# POMDPSolve.jl
[![CI](https://github.com/JuliaPOMDP/POMDPSolve.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaPOMDP/POMDPSolve.jl/actions/workflows/CI.yml)
[![codecov.io](http://codecov.io/github/JuliaPOMDP/POMDPSolve.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaPOMDP/POMDPSolve.jl?branch=master)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaPOMDP.github.io/POMDPSolve.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaPOMDP.github.io/POMDPSolve.jl/dev)

This is a Julia wrapper for the POMDP-Solve program, orginally developed at Brown University that uses the [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) interface. This package uses the [POMDPSolve_jll](https://github.com/JuliaBinaryWrappers/POMDPSolve_jll.jl) package, which was build using modifications from the code available from Tony Cassandra's [pomdp.org page](http://www.pomdp.org/code/index.html). The modfications are available in the [JuliaPOMDP fork of pomdp-solve](https://github.com/JuliaPOMDP/pomdp-solve).

The pomdp-solve program solves partially observable Markov decision
processes (POMDPs), taking a model specification and producing a value
function and action policy.  It employs many different algorithms,
some exact and some approximate.

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

## Parameters
Reference this package documentation for information on parameters and parameter options for the solver. If the information cannot be found there, please refer to the JuliaPOMDP fork of pomdp-solve or the original pomdp-solve documentation.

## POMDPSolve_jll
The supporting [POMDPSolve_jll](https://github.com/JuliaBinaryWrappers/POMDPSolve_jll.jl) package was created using [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl). The [build_tarballs.jl](https://github.com/JuliaPackaging/Yggdrasil/blob/master/P/POMDPSolve/build_tarballs.jl) script can be found on [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/), the community build tree. To update and build new binaries:
 - Modify the JuliaPOMDP fork of [pomdp-solve](https://github.com/JuliaPOMDP/pomdp-solve)
  - Fork and update the Yggdrasil POMDPSolve_jll [build_tarballs.jl](https://github.com/JuliaPackaging/Yggdrasil/blob/master/P/POMDPSolve/build_tarballs.jl) script 
  - Create a pull request on [JuliaPackaging/Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
