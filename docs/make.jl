using JuliaOptimizationChallenge
using Documenter

DocMeta.setdocmeta!(JuliaOptimizationChallenge, :DocTestSetup, :(using JuliaOptimizationChallenge); recursive=true)

makedocs(;
    modules=[JuliaOptimizationChallenge],
    authors="yanwu-728 <74961465+yanwu-728@users.noreply.github.com> and contributors",
    repo="https://github.com/yanwu-728/JuliaOptimizationChallenge.jl/blob/{commit}{path}#{line}",
    sitename="JuliaOptimizationChallenge.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://yanwu-728.github.io/JuliaOptimizationChallenge.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/yanwu-728/JuliaOptimizationChallenge.jl",
    devbranch="master",
)

```@docs
DocumenterShowcase
```
