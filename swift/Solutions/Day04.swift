//
//  Day04.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/3/23.
//

import Foundation

struct Day04: Day{
    func part1Solution(input: [String]) -> String {
        var answer = 0
        input.forEach { game in
            let numbers = game.split(separator: ":")[1].split(separator:"|")
            let winningNumbers = numbers[0].split(separator:" ").map { Int($0)!}
            let actualNumbers = numbers[1].split(separator:" ").map { Int($0)!}
            let intersection = Set(winningNumbers).intersection(actualNumbers)
            if(!intersection.isEmpty){
                answer += Int(pow(Double(2), Double(intersection.count-1)))
            }
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var lineMultipliers = [Int](repeating: 1, count: input.count)
        for (idx, game) in input.enumerated(){
            let numbers = game.split(separator: ":")[1].split(separator:"|")
            let winningNumbers = numbers[0].split(separator:" ").map { Int($0)!}
            let actualNumbers = numbers[1].split(separator:" ").map { Int($0)!}
            
            let intersection = Set(winningNumbers).intersection(actualNumbers)
            
            let multiplier = lineMultipliers[idx]
            if(!intersection.isEmpty){
                for gameNum in 1...intersection.count {
                    lineMultipliers[idx+gameNum] += multiplier
                }
            }
        }
        
        return "\(lineMultipliers.reduce(0, +))"
    }
    
    
}
