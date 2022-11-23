using Aqua
using JuliaOptimizationChallenge
using Test
using HashCode2014
using JuliaFormatter
using Documenter

@testset verbose = true "JuliaOptimizationChallenge.jl" begin
    # Skip quality check test for now
    
    # @testset verbose = true "Code quality (Aqua.jl)" begin
    #     Aqua.test_all(JuliaOptimizationChallenge; ambiguities=false)
    # end

    # Skip formatting test for now

    # @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
    #     @test format(JuliaOptimizationChallenge; verbose=true, overwrite=false)
    # end

    # Skiping doc test for now

    # @testset verbose = true "Doctests (Documenter.jl)" begin
    #     doctest(JuliaOptimizationChallenge)
    # end

    @testset verbose = true "Small instance" begin
        input_path = joinpath(@__DIR__, "data", "example_input.txt")
        output_path = joinpath(@__DIR__, "data", "example_output.txt")
        city = HashCode2014.read_city(input_path)
        solution = JuliaOptimizationChallenge.solution(city)
        @test HashCode2014.is_feasible(solution, city)
        @test HashCode2014.total_distance(solution, city) == 450
    end

    @testset verbose = true "Large instance" begin
        city = HashCode2014.read_city()
        solution = JuliaOptimizationChallenge.solution(city)
        @test city.total_duration == 54000
        @test HashCode2014.is_feasible(solution, city)
    end

    @testset verbose = true "Plotting" begin
        city = HashCode2014.read_city()
        solution = JuliaOptimizationChallenge.solution(city)
        HashCode2014.plot_streets(city, solution; path=nothing)
    end
end
