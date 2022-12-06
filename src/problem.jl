"""@docs
Problem
Problem(city)
"""

"""
Store a problem which represents a city using a matrix and other parameters

#Fields

-total_duration::Int: total time allotted for the car itineraries (in seconds)
-nb_cars::Int: number of cars in the fleet
-starting_junction::Int: junction at which all the cars are located initially
-junctions::Vector{Junction}: list of junctions
-adjacency::Vector{Vector{Street}} list where ith entry is all the streets that you can travel through from ith junction
"""
struct Problem
    total_duration::Int
    nb_cars::Int
    starting_junction::Int
    junctions::Vector{Junction}
    adjacency::Vector{Vector{Street}}
end

"""
Creates a Problem instance using a HashCode2014.jl City object
"""
function Problem(city::City)
    J = size(city.junctions)
    A = Vector{Vector{Street}}(Vector{Street}(undef,0),J)

    for street in city.streets
        (;endpointA,endpointB,bidirectional,duration,distance) = street
        A[endpointA].append!([street])
        if bidirectional
            A[endpointB].append!([street])
        end
    end

    problem = Problem(;
        total_duration=city.total_duration,
        nb_cars=city.nb_cars,
        start=city.starting_junction,
        junctions=city.junctions,
        adjacency=A
    )
    return problem
end