using HashCode2014

"""
    compute_upper_bound()

Calculate an upper bound on the number of meters that can be covered
"""
function compute_upper_bound()
    city = HashCode2014.read_city()
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    return
end