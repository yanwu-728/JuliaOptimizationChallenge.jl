using Aqua
using JuliaOptimizationChallenge
using Test
using HashCode2014
using JuliaFormatter
using Documenter

@testset verbose = true "JuliaOptimizationChallenge.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(JuliaOptimizationChallenge; ambiguities=false)
    end

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
        # println(problem.adjacency)
        solution = JuliaOptimizationChallenge.solver(problem)
        @test city.total_duration == 54000
        @test is_feasible(solution, city)
        HashCode2014.write_solution(solution, "../solution/solution.txt")
        println("Total distance: ", HashCode2014.total_distance(solution, city))
        # #println("Total_duration: ", total_duration)
        HashCode2014.plot_streets(city, solution; path="../solution/solution.html")
    end

    @testset verbose = true "Plotting" begin
        city = read_city()
        problem = JuliaOptimizationChallenge.Problem(city)
        solution = JuliaOptimizationChallenge.solver(problem)
        plot_streets(city, solution; path=nothing)
    end
end
