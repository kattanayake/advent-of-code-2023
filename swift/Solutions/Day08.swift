//
//  Day08.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/7/23.
//

import Foundation

struct Day08: Day {
    func part1Solution(input: [String]) -> String {
        let instructions = input[0]
        var nodes = [String: [String]]()
        input[1...].forEach { line in
            let lineParts = line.split(separator: "=")
            nodes[String(lineParts[0]).trimmingCharacters(in: .whitespaces)] = lineParts[1].split(separator: ",").map{
                $0.trimmingCharacters(in: CharacterSet(charactersIn: "() ") )
            }
        }
        var curNode = "AAA"
        var curIndex = 0
        var answer = 0
        
        while(curNode != "ZZZ"){
            let direction = instructions[curIndex]
            let newIndex: Int
            if (direction == "L") { newIndex = 0} else { newIndex = 1}
            curNode = nodes[curNode]![newIndex]
            answer += 1
            curIndex = (curIndex + 1) % instructions.count
        }
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let instructions = input[0]
        var nodes = [String: [String]]()
        input[1...].forEach { line in
            let lineParts = line.split(separator: "=")
            nodes[String(lineParts[0]).trimmingCharacters(in: .whitespaces)] = lineParts[1].split(separator: ",").map{
                $0.trimmingCharacters(in: CharacterSet(charactersIn: "() ") )
            }
        }
        
        var curNodes = nodes.keys.filter { $0.last == "A" }
        var curIndex = 0
        var iteration = 0
        var LCMs = [Int](repeating: -1, count: curNodes.count)
        while(!LCMs.allSatisfy { $0 != -1}){
            let direction = instructions[curIndex]
            let newIndex: Int
            if (direction == "L") { newIndex = 0} else { newIndex = 1}
            for (idx, curNode) in curNodes.enumerated() {
                curNodes[idx] = nodes[curNode]![newIndex]
                if(curNodes[idx].last == "Z" && LCMs[idx] == -1){
                    LCMs[idx] = iteration + 1
                }
            }
            iteration += 1
            curIndex = (curIndex + 1) % instructions.count
        }
        
        var accumulator = 1
        for value in LCMs {
            accumulator = lcm(accumulator, value)
        }
        
        return "\(accumulator)"
    }
    
    
}
