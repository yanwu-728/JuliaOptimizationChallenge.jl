"""@docs
compute_upper_bound(city)
"""

"""
Calculate an upper bound on the number of meters that can be covered using a HashCode2014.jl City instance
"""
function compute_upper_bound(city)
    #Make an upper bound that depends on the parameters of the problem like time allowed, number of cars, ...
    #Can be anything as long as you justify a proof for this that you include in documentation
    #Idea: Calculate the total duration and distance of all of the streets. If total duration>allowed, remove duration 
    #and distance from the slowest streets (i.e. smalles distance/time)
    bound = 0
    (; total_duration, nb_cars, starting_junction, streets) = city
    for street in streets
        bound += street.distance
    end
    return bound
end
