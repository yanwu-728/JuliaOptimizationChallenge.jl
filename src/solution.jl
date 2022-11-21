using HashCode2014
using BenchmarkTools

function solution()
    city = HashCode2014.read_city()
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    visited = Set()
    for car in 1:nb_cars
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            candidates = [
                (s, street) for (s, street) in enumerate(streets) if (
                    HashCode2014.is_street_start(current_junction, street) &&
                    duration + street.duration <= total_duration
                )
            ]
            if isempty(candidates)
                break
            else
                not_visited = [(s, street) for (s, street) in candidates if (!(street in visited))]
                if isempty(not_visited)
                    s, street = rand(candidates)
                else
                    s, street = rand(not_visited)
                end
                next_junction = HashCode2014.get_street_end(current_junction, street)
                push!(itinerary, next_junction)
                push!(visited, street)
                duration += street.duration
            end
        end
        itineraries[car] = itinerary
    end
    
    # if isfile("../solution/solution.txt")
    #     HashCode2014.write_solution(HashCode2014.Solution(itineraries), "../solution/solution.txt")
    # else 
    #     touch("../solution/solution.txt")
    #     HashCode2014.write_solution(HashCode2014.Solution(itineraries), "../solution/solution.txt")
    #end
    println("Total distance: ", HashCode2014.total_distance(HashCode2014.Solution(itineraries), city))
    println("Total_duration: ", total_duration)
    #HashCode2014.plot_streets(city, HashCode2014.Solution(itineraries); path="../solution/solution.html")
end

@benchmark solution()

