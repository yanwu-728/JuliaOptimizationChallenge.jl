using Aqua
using JuliaOptimizationChallenge
using Test
using HashCode2014
using JuliaFormatter

@testset verbose = true "JuliaOptimizationChallenge.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(JuliaOptimizationChallenge; ambiguities=false)
    end

    # Skip formatting test for now
    
    # @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
    #     @test format(JuliaOptimizationChallenge; verbose=true, overwrite=false)
    # end

    # Skiping doc test for now

    # @testset verbose = true "Doctests (Documenter.jl)" begin
    #     doctest(JuliaOptimizationChallenge)
    # end

    @testset verbose = true "Large instance" begin
        city = HashCode2014.read_city()
        solution = solution(city)
        @test city.total_duration == 54000
        @test HashCode2014.is_feasible(solution, city)
    end

    @testset verbose = true "Plotting" begin
        city = HashCode2014.read_city()
        solution = solution(city)
        HashCode2014.plot_streets(city, solution; path=nothing)
    end
end
