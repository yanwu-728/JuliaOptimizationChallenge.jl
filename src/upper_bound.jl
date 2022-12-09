using HashCode2014

"""@docs
compute_upper_bound(city)
"""

"""
Calculate an upper bound on the number of meters that can be covered using a HashCode2014.jl City instance
"""
function compute_upper_bound(city)
    upper_bound = 0
    time = 0
    (; total_duration, nb_cars, starting_junction, streets) = city
    sort!(streets; by=street -> street.distance / street.duration, rev=true)
    for street in streets
        time += street.duration
        if time < total_duration * nb_cars
            upper_bound += street.distance
        else
            upper_bound +=
                street.distance * (total_duration * nb_cars - (time - street.duration)) /
                street.duration
            break
        end
    end
    return upper_bound
end
