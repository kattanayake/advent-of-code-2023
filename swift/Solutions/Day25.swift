//
//  Day25.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/24/23.
//

import Foundation

struct Day25: Day {
    
    /// I was lazy and ended up using Python and the NetworkX module to solve this problem
    /// If I were to have done this in Swift, I would have used Karger's Algorithm (https://en.wikipedia.org/wiki/Karger%27s_algorithm)
    /// The solution would be to run Karger's several times and collect the number of 3-cut solutions it generates (to account for the algorithm's non-determinism)
    /// The most commonly generated 3-cut solution is likely to be the solution. We can then remove the edges found by that solution, and run BFS
    /// on each of the nodes to find how many groups there are and how big they are. 
    
    func part1Solution(input: [String]) -> String {
        let answer = 0
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let answer = 0
        return "\(answer)"
    }
}
