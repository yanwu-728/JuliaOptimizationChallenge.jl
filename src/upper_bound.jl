using HashCode2014

"""@docs
compute_upper_bound(city)
"""

"""
Calculate an upper bound on the number of meters that can be covered using a HashCode2014.jl City instance
"""
function compute_upper_bound(city)
    # Justify a proof for this that you include in documentation
    # Idea: Calculate the total duration and distance of all of the streets. If total duration>allowed*nb_cars, remove duration 
    # and distance from the slowest streets (i.e. smalles distance/time)
    upper_bound = 0
    time = 0
    (; total_duration, nb_cars, starting_junction, streets) = city
    sort!(streets; by=street -> street.distance / street.duration, rev=true)
    for street in streets
        time += street.duration
        if time < total_duration * nb_cars
            upper_bound += street.distance
        else
            break
        end
    end
    return upper_bound
end
