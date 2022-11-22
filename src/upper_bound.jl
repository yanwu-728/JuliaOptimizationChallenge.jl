using HashCode2014

function compute_upper_bound()
    city = HashCode2014.read_city()
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    return
end