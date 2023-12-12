//
//  Day12.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/11/23.
//

import Foundation

struct Day12: Day {
    func part1Solution(input: [String]) -> String {
        var answer = 0
        var cache = [Checkpoint: Int]()
        
        input.forEach { line in
            let lineParts = line.split(separator: " ")
            let springs = String(lineParts[0])
            let groupings = lineParts[1].split(separator: ",").map { Int($0)! }
            answer += goDeeper(springs, groupings, 0, &cache)
        }
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var answer = 0
        var cache = [Checkpoint: Int]()
        var lineNum = 0
        input.forEach { line in
            let lineParts = line.split(separator: " ")
            let springs = String(lineParts[0])
            var springsAlt = springs
            let groupings = lineParts[1].split(separator: ",").map { Int($0)! }
            var groupingsAlt = groupings
            
            for _ in 1..<5 {
                springsAlt += ("?" + springs)
                groupingsAlt += groupings
            }
            answer += goDeeper(springsAlt, groupingsAlt, 0, &cache)
            lineNum += 1
        }
        
        return "\(answer)"
    }
    
    func goDeeper(_ line: String, _ values: [Int], _ index: Int, _ cache: inout [Checkpoint: Int]) -> Int {
        if index >= line.count {
            if values.isEmpty {
                return 1
            }
            return 0
        }
        
        var answer = 0
        let checkpoint = Checkpoint(substring: String(line[index...]), groupings: values)
        if let cachedValue = cache[checkpoint] {
            return cachedValue
        }
        
        if !values.isEmpty {
            if (index+(values[0] - 1) < line.count),
               line[index..<(index+values[0])].allSatisfy ({ $0 == "?" || $0 == "#" }),
               (index+values[0] == line.count || line[index+values[0]] != "#")
            {
                answer += goDeeper(line, values[1...].map { $0 }, index + values[0] + 1, &cache)
            }
            if line[index] == "#" {
                cache[checkpoint] = answer
                return answer
            }
            answer += goDeeper(line, values, index + 1, &cache)
        } else if line[index] == "#" {
            cache[checkpoint] = answer
            return answer
        } else {
            answer += goDeeper(line, values, index + 1, &cache)
        }
        cache[checkpoint] = answer
        return answer
    }
    
}

struct Checkpoint: Hashable {
    let substring: String
    let groupings: [Int]
}
