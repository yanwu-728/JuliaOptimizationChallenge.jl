"""@docs
solver_parallel_lookforward(problem)
find_lookforward_paths_parallel(initial_junction,visited,adjacency,steps)
"""

"""
Find all possible paths at certain junction, with the current visited street.
# Output
    The optimal path at N steps
"""
function find_lookforward_paths_parallel(initial_junction, visited, adjacency, steps)
    paths = []
    current_junctions = []
    path_distance = []
    # initiate the path and junctions
    for (s, street) in enumerate(adjacency[initial_junction])
        push!(paths, [street])
        push!(current_junctions, HashCode2014.get_street_end(initial_junction, street))
        if !(street in visited)
            push!(path_distance, street.distance)
        else
            push!(path_distance, 0)
        end
    end
    #looking forward to N steps
    for iter in 1:steps
        old_paths = paths
        old_junctions = current_junctions
        old_path_distance = path_distance
        paths = []
        current_junctions = []
        path_distance = []
        for idx in 1:length(old_paths)
            for (s, street) in enumerate(adjacency[old_junctions[idx]])
                update_old_path = reverse(append!([street], reverse(old_paths[idx]))) #[]
                push!(paths, update_old_path)
                push!(
                    current_junctions,
                    HashCode2014.get_street_end(old_junctions[idx], street),
                )
                if !(street in visited) && !(street in old_paths[idx])
                    push!(path_distance, old_path_distance[idx] + street.distance)
                else
                    push!(path_distance, old_path_distance[idx])
                end
            end
        end
    end
    max_distance_idx = argmax(path_distance)
    if path_distance[max_distance_idx] == 0
        return []
    end
    return paths[max_distance_idx]
end
"""
Find a possible solution of itineraries for each car, given a problem instance
# Output
    - a set of itineraries for each of the cars
"""
function solver_parallel_lookforward(problem)
    (; total_duration, nb_cars, starting_junction, adjacency) = problem
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    visited = Set{Street}()
    #initialize the positions
    for i in 1:nb_cars
        itineraries[i] = [starting_junction]
    end

    duration = zeros(nb_cars)
    while true
        flag = zeros(nb_cars) # label if the car runs out of the time
        for car in 1:nb_cars
            current_junction = last(itineraries[car])
            candidates = [
                (s, street) for (s, street) in enumerate(adjacency[current_junction]) if
                (duration[car] + street.duration <= total_duration)
            ]
            #evaluate 

            if isempty(candidates)
                flag[car] = 1 # labels that the car is run out of the time
                continue
            else
                not_visited = [
                    (s, street) for (s, street) in candidates if (!(street in visited))
                ]
                not_visited_meter_per_second = [
                    street.distance for (s, street) in not_visited
                ]
                if isempty(not_visited)
                    s, selected_street = rand(candidates)
                else
                    path = find_lookforward_paths_parallel(
                        current_junction, visited, adjacency, 5
                    )

                    selected_street = first(path)
                    if selected_street in visited
                        s, selected_street = rand(not_visited)
                    end
                end

                ### choose the path###
                push!(visited, selected_street)
                next_junction = HashCode2014.get_street_end(
                    current_junction, selected_street
                )
                push!(itineraries[car], next_junction)

                duration[car] += selected_street.duration
            end
        end
        if !(0 in flag) # if all cars run out of their time
            break
        end
    end

    return HashCode2014.Solution(itineraries)
end
