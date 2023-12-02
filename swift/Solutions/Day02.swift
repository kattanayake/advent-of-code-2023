//
//  Day02.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/1/23.
//

import Foundation

struct Day02: Day {
    func part1Solution(input: [String]) -> String {
        let redMax = 12
        let greenMax = 13
        let blueMax = 14
        
        var answer = 0
        input.forEach{ line in
            var gameIsBad = false
            line.split(separator: ":")[1]
                .split(separator: ";").forEach { round in
                    var redCount = 0
                    var greenCount = 0
                    var blueCount = 0
                    round.split(separator: ",").forEach { pair in
                        let parts = pair.split(separator: " ")
                        if(parts[1] == "red"){
                            redCount += Int(parts[0])!
                        } else if (parts[1] == "green"){
                            greenCount += Int(parts[0])!
                        } else if (parts[1] == "blue"){
                            blueCount += Int(parts[0])!
                        }
                    }
                    if(redCount > redMax || blueCount > blueMax || greenCount > greenMax){
                        gameIsBad = true
                    }
                }
            if (!gameIsBad) {
                answer += Int(line.split(separator: ":")[0].split(separator: " ")[1])!
            }
        }
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var answer = 0
        input.forEach{ line in
            var redCount = 0
            var greenCount = 0
            var blueCount = 0
            line.split(separator: ":")[1]
                .split(separator: ";").forEach { round in
                    round.split(separator: ",").forEach { pair in
                        let parts = pair.split(separator: " ")
                        if(parts[1] == "red"){
                            redCount = max(redCount, Int(parts[0])!)
                        } else if (parts[1] == "green"){
                            greenCount = max(greenCount, Int(parts[0])!)
                        } else if (parts[1] == "blue"){
                            blueCount = max(blueCount, Int(parts[0])!)
                        }
                    }
                }
            answer += (redCount * greenCount * blueCount)
        }
        
        return "\(answer)"
    }
}
