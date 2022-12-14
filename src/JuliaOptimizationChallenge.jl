# Unless you have a reason not to precompile, you should set your package to precompile.

# Reasons to not precompile:
# 1) You have global pointers. This includes any globally defined Bigs! These
#    will cause segfaults.
# 2) You are calling `@eval` in a function that modifies your modules' global scope
#    This may have bad interactions with precompilation.
# 3) You are importing/using a package which has precompilation disabled

# __precompile__()

# If you are not going to precompile your package, it's good practice to disable it:
# __precompile__(false)

module JuliaOptimizationChallenge

# The main module file is for outlining the structure of the package.
# At the top of your package module, you should import your dependencies:

using HashCode2014

# Some people make sure all export statements are at the top of the main module as well
# Only values which are exported enter the namespace, anything else must be
# qualified by the package name (ExamplePackage.not_exported). By doing this all
# at the top file, it is easy to know what functionality is exported by a package

# Note: You should try to keep exports to a minimum. Exports are the public API:
# internal functionality should not be exported!

export Problem
export compute_upper_bound
export solver_parallel_lookforward

# Now include the real code
# Write your code in other files, otherwise the package outline gets muddled

include("problem.jl")
include("solver_parallel_lookforward.jl")
include("upper_bound.jl")

end # module
