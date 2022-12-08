using HashCode2014
using BenchmarkTools

function itinerary_solution(city)
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

city = HashCode2014.read_city()
# cur_solution = solution(city)
# 
# 

function greedy_helper(city, car_index, duration, itineraries, path_length, visited=Set())
    """
    city: a object of city struct from HashCode2014.jl
    car_index: an integer indicating the index of the car that we current look at
    duration: the current duration
    itineraries: a list of lists containing a sequence of street (s, street) that each car has traversed so far.
    path_length: how far do we want to look ahead. The number of step that we pre-compute to find the best next street
    visited: a set containing the (s, street) that we have visited in total
    """
    if path_length == 0
        return 0, 0
    end

    (; total_duration, nb_cars, starting_junction, streets) = city
    total_duration = 1000
    # Find all the candidates for each car and the possible streets they could go to
    current_junctions = []
    candidates = [[] for _ in 1:nb_cars]
    for i in 1:nb_cars
        current_junction = last(itineraries[i])
        push!(current_junctions, current_junction)
    end

    for (s, street) in enumerate(streets) 
        for i in 1:nb_cars
            current_junction = current_junctions[i]
            if ( 
                HashCode2014.is_street_start(current_junction, street) &&
                duration + street.duration <= total_duration
            )
            push!(candidates[i], (s, street))
            end
        end
    end
    if length(candidates[car_index]) == 0
        return 0, 0
    end
    # For each street that the given car is going next, compute the score obtained by other cars greedily
    # All the candidates are in form of (s, street), so when calling for duration, needs to do candidate[1].duration
    current_score = [0 for _ in 1:length(candidates[car_index])]
    has_candidate = true

    for targeted_candidate_index in 1:length(candidates[car_index])
        targeted_candidate = candidates[car_index][targeted_candidate_index]
        new_visited = copy(visited)
        push!(new_visited, targeted_candidate)

        new_itineraries = deepcopy(itineraries)
        targeted_junction = HashCode2014.get_street_end(last(new_itineraries[car_index]), targeted_candidate[2])
        push!(new_itineraries[car_index], targeted_junction)

        best_candidate = 0
        for i in 1:nb_cars
            if i != car_index
                if length(candidates[i]) != 0
                    best_current_candidate = 0
                    current_candidates = candidates[i]
                    current_junction = last(new_itineraries[i])
                    # Take the candidate by its duration value greedily
                    for candidate_index in 1:length(current_candidates)
                        candidate = current_candidates[candidate_index]
                        if  (!(candidate in new_visited) && ((best_candidate == 0) || ((candidate[1].distance / candidate[1].duration) > (best_candidate[1].distance / best_candidate[1].duration))))
                            best_current_candidate = candidate
                        end
                    end

                    if best_current_candidate == 0
                        best_current_candidate = rand(current_candidates)
                        has_candidate = false
                    end

                    next_junction = HashCode2014.get_street_end(current_junction, best_current_candidate[2])
                    push!(new_visited, best_current_candidate)
                    push!(new_itineraries[i], next_junction)
                    if has_candidate
                        current_score[targeted_candidate_index] += best_current_candidate[2].distance
                    else
                        current_score[targeted_candidate_index] -= best_current_candidate[2].distance
                        has_candidate = true
                    end
                end
            end
        end
        next_best_scores = greedy_helper(city, car_index, duration + targeted_candidate[2].duration, new_itineraries, path_length - 1, new_visited)[1]
        if next_best_scores != 0
            current_score[targeted_candidate_index] += maximum(next_best_scores)
        end
    end

    best_candidate_index = 0
    best_score= 0
    for targeted_candidate_index in 1:length(candidates[car_index])
        if best_score <= current_score[targeted_candidate_index]
            best_score = current_score[targeted_candidate_index]
            best_candidate_index = targeted_candidate_index
        end
    end
    return current_score, candidates[car_index][best_candidate_index]
end

function greedy_look_ahead(city)
    (; total_duration, nb_cars, starting_junction, streets) = city
    total_duration = 1000
    itineraries = [[starting_junction] for _ in 1:nb_cars]
    durations = [0 for _ in 1:nb_cars]
    visited = Set()
    while minimum(durations) < total_duration
        current_itineraries = itineraries
        for car in 1:nb_cars
            if durations[car] != -1
                itinerary = itineraries[car]
                current_junction = last(itinerary)
                _, street = greedy_helper(city, car, durations[car], current_itineraries, 5, visited)
                if street != 0
                    next_junction = HashCode2014.get_street_end(current_junction, street[2])
                    durations[car] += street[2].duration
                    if durations[car] < total_duration
                        push!(itineraries[car], next_junction)
                        push!(visited, street)
                    end
                else
                    durations[car] = total_duration
                end
            end
        end
        println(durations)
    end
    HashCode2014.write_solution(HashCode2014.Solution(itineraries), "solution.txt")
    println("Total distance: ", HashCode2014.total_distance(HashCode2014.Solution(itineraries), city))
    println("Total_duration: ", total_duration)
    HashCode2014.plot_streets(city, HashCode2014.Solution(itineraries); path="solution.html")
    return HashCode2014.Solution(itineraries)
end

city = HashCode2014.read_city()
# city = HashCode2014.read_city("test/data/example_input.txt")
greedy_look_ahead_solution = greedy_look_ahead(city)
