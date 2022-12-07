"""@docs
compute_upper_bound(city)
"""

"""
Calculate an upper bound on the number of meters that can be covered using a HashCode2014.jl City instance
"""
function compute_upper_bound(city)
    bound = 0
    #total_duration, nb_cars, starting_junction, streets
    (; total_duration, nb_cars, starting_junction, streets) = city
    for street in streets
        bound += street.distance
    end
    return bound
end