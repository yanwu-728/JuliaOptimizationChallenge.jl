"""@docs
solver(problem)
"""

"""
Find a possible solution of itineraries for each car, given a problem instance
# Output
    - a set of itineraries for each of the cars in the form of a HashCode2014 Solution
"""
function solver(problem)
    (; total_duration, nb_cars, starting_junction, adjacency) = problem
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    visited = Set{Street}()
    for car in 1:nb_cars
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            candidates = [
                (s, street) for (s, street) in enumerate(adjacency[current_junction]) if
                (duration + street.duration <= total_duration)
            ]
            #evaluate
            if isempty(candidates)
                break
            else
                not_visited = [
                    (s, street) for (s, street) in candidates if (!(street in visited))
                ]
                not_visited_meter_per_second = [
                            street.distance for (s, street) in not_visited
                ]
                if isempty(not_visited)
                    s, street = rand(candidates)
                else
                    s, street = not_visited[argmax(not_visited_meter_per_second)]
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
