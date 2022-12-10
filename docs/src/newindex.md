# JuliaOptimizationChallenge

## Data Structure
We modified the original data structure from HashCode2014.jl to store additional information.
In particular, the streets now could be stored in an adjacency list, which allows one to easily have access to all the outgoing streets
given a junction. This will be particularly useful if we would like to make a comparision among different options a car could take given
that the last junction the car is at.

## Solver Algorithm


### Description

The algorithm we used is the greedy algorithm with looking forward. We optimize all car routines in parallel.
For each step, we decide if there is any unvisited street. If not, we randomly select one. If so, we will look forward for 8 steps, and get the first step for the optimial path. 
If the selected street is visited, we will randomly choose another one in the unvisited streets as the next step. If the selected street is not visited, we will choose it as the next step.
The process is performed until all cars meet the maximum duration.

### Efficiency

- We choose to optimize 8 cars in parallel to increase the efficiency
- Assign a type for any collection of elements that we created
- Used push! and append! to add to vectors without creating a new vector
- Keep track of the junction visited using a set so that we can check if a junction has been visited in constant time

## Upper Bound

### Description

We computed our upper bound by adding up the distances of all of the streets in order from fastest to slowest until we reached the total duration times the number of cars. Note that when we reach a point that we can't include an entire street without going over the time limit, we take whatever fraction of the street we can take.

### Proof
Let OPT be some optimal solution for the upper bound problem. Assume for contradiction that OPT differs from our solution in portion of at least one street. In this case, there is some fraction of some street, s* , that is in OPT that was not included in our upper bound algorithm. Since we include streets in order of decreasing speed, s* must be no faster than any street we included in the upper bound. Let the chunk of s* that we don't include have distance d* and duration t* . Notice that for any chunk of t* time, the streets that are included in our upper bound will all have contributed a distance of at least d* because they were all at least as fast as s* . Therefore, if we replace any chunk of duration t* in our upper bound with a chunk from s* of equal duration, the total distance covered will either stay the same or decrease. Notice that if the distance stays the same, then we can repeat this process until our upper bound was transformed into OPT with the total distance. This would imply that our upper bound was optimal to begin with. Otherwise, if the distance decreases when we swap in s* , this would imply that OPT was not optimal because our upper bound was better which is a contradiction. Since our assumption was that OPT differs from our upper bound, this contradiction would imply that OPT is the same as our upper bound. Therefore, there must exist no way to pick streets such that the sum of the durations is at most total_duration and sum of the distance is larger than our upper bound.

### Runtime
The algorithm takes O(nlogn) time where n is the number of streets. Sorting the streets by the speed takes O(nlogn) time, and the greedy algorithm of traversing each street and take the distance takes O(n) time. 

### Efficiency

- Used sort! to sort in place instead of creating a new vector
