//
//  Day06.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/5/23.
//

import Foundation

struct Day06: Day {
    func part1Solution(input: [String]) -> String {
        let times = input[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        let distances = input[1].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        var answers = [Int]()
        
        for index in 0..<times.count {
            var permutations = 0
            let target = distances[index]
            let time = times[index]
            for dur in 0...time {
                if (dur * (time - dur)) > target {
                    permutations += 1
                }
            }
            answers.append(permutations)
        }
        
        return "\(answers.reduce(1, *))"
    }
    
    func part2Solution(input: [String]) -> String {
        let time = Int(input[0].split(separator: ":")[1].split(separator: " ").joined())!
        let distance = Int(input[1].split(separator: ":")[1].split(separator: " ").joined())!
        var permutations = 0
        for dur in 0...time {
            if (dur * (time - dur)) > distance {
                permutations += 1
            }
        }

        return "\(permutations)"
    }
    
    
}
