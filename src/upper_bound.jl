"""@docs
compute_upper_bound(city)
"""

"""
Calculate an upper bound on the number of meters that can be covered

# Arguments
    - 'city': a City object from HashCode2014.jl
"""
function compute_upper_bound(city)
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    return
end