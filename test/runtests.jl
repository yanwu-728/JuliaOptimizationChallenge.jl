using Aqua
using JuliaOptimizationChallenge
using Test
using HashCode2014
using JuliaFormatter

@testset verbose = true "JuliaOptimizationChallenge.jl" begin
    # Skip quality check for now

    # @testset verbose = true "Code quality (Aqua.jl)" begin
    #     Aqua.test_all(JuliaOptimizationChallenge; ambiguities=false)
    # end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(JuliaOptimizationChallenge; verbose=true, overwrite=false)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(JuliaOptimizationChallenge)
    end

    @testset verbose = true "Small instance" begin
        input_path = joinpath(@__DIR__, "data", "example_input.txt")
        output_path = joinpath(@__DIR__, "data", "example_output.txt")
        city = read_city(input_path)
        problem = JuliaOptimizationChallenge.Problem(city)
        solution = JuliaOptimizationChallenge.solver(problem)
        @test is_feasible(solution, city)
        @test total_distance(solution, city) == 450
    end

    @testset verbose = true "Large instance" begin
        city = read_city()
        problem = JuliaOptimizationChallenge.Problem(city)
        solution = JuliaOptimizationChallenge.solver(problem)
        @test city.total_duration == 54000
        @test is_feasible(solution, city)
    end

    @testset verbose = true "Plotting" begin
        city = read_city()
        problem = JuliaOptimizationChallenge.Problem(city)
        solution = JuliaOptimizationChallenge.solver(problem)
        plot_streets(city, solution; path=nothing)
    end
end
