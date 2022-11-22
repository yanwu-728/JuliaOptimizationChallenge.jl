using Aqua
using JuliaOptimizationChallenge
using Test
using HashCode2014

@testset  begin
    solution()
    evaluate_performance()
end

@testset verbose = true "JuliaOptimizationChallenge.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(JuliaOptimizationChallenge; ambiguities=false)
    end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(JuliaOptimizationChallenge; verbose=true, overwrite=false)
    end

    # Skip doc test for now

    # @testset verbose = true "Doctests (Documenter.jl)" begin
    #     doctest(JuliaOptimizationChallenge)
    # end

    @testset verbose = true "Small instance" begin
        input_path = joinpath(@__DIR__, "data", "example_input.txt")
        output_path = joinpath(@__DIR__, "data", "example_output.txt")
        city = HashCode2014.read_city(input_path)
        solution = HashCode2014.read_solution(output_path)
        open(input_path, "r") do file
            @test string(city) == read(file, String)
        end
        open(output_path, "r") do file
            @test string(solution) == read(file, String)
        end
        @test is_feasible(solution, city)
        @test total_distance(solution, city) == 450
    end

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
