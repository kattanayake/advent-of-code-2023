//
//  Day09.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/7/23.
//

import Foundation

struct Day09: Day {
    func part1Solution(input: [String]) -> String {
        var answer = 0
        for line in input {
            let parsedNum = line.split(separator: " ").map { Int($0)! }
            answer += parsedNum.last! + extrapolate(parsedNum)
        }
        return "\(answer)"
    }
    
    private func extrapolate(_ numbers: [Int]) -> Int {
        if(numbers.allSatisfy { $0 == 0 }) { return 0 }
        let nextSequence = (1..<numbers.count).map {
            numbers[$0] - numbers[$0 - 1]
        }
        return extrapolate(nextSequence) + nextSequence.last!
    }
    
    private func extrapolateBackwards(_ numbers: [Int]) -> Int {
        if(numbers.allSatisfy { $0 == 0 }) { return 0 }
        let nextSequence = (1..<numbers.count).map {
            numbers[$0] - numbers[$0 - 1]
        }
        return nextSequence.first! - extrapolateBackwards(nextSequence)
    }
    
    func part2Solution(input: [String]) -> String {
        var answer = 0
        for line in input {
            let parsedNum = line.split(separator: " ").map { Int($0)! }
            answer += parsedNum.first! - extrapolateBackwards(parsedNum)
        }
        return "\(answer)"
    }
    
    
}
