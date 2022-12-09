# JuliaOptimizationChallenge


## Algorithm

The algorithm we used is...

## Upper Bound

We computed our upper bound by adding up the distances of all of the streets in order from fastest to slowest until we reached the total duration times the number of cars. 

Assume for contradiction that there was some optimal solution that covered more distance in the allowed time than this upper bound. In this case, there is at least one street that the optimal solution covered that our upper bound algorithm didn't cover. 
<!-- Essentially added the fastest streets until the total sum of the durations is greater than the total_duration times the number of cars-->

## Efficiency

Some choiced we made to improve efficiency were...
