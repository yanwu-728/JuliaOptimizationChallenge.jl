using HashCode2014
#using BenchmarkTools

"""
    Find a possible solution of itineraries for each car, given a city object

    input: city object with total_duration, nb_cars, starting_junction, and streets values

    output: a set of itineraries for each of the cars
"""
function solution(city)
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
    return HashCode2014.Solution(itineraries)
end

