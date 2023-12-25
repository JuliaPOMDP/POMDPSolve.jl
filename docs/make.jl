using POMDPSolve
using POMDPs
using Documenter

makedocs(;
    modules=[POMDPSolve],
    sitename="POMDPSolve.jl",
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
    checkdocs = :none,
)

deploydocs(;
    repo="github.com/JuliaPOMDP/POMDPSolve.jl.git",
    devbranch = "master",
    versions = ["stable" => "v^", "v#.#"]
)
