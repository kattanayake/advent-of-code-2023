//
//  Day01.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 11/29/23.
//

import Foundation

struct Day01: Day {
    func part1Solution(input: [String]) -> String {
        var answer = 0
        input.forEach { line in
            var first: Character? = nil
            var last: Character? = nil
            line.forEach { char in
                if(char.isNumber){
                    if(first == nil){
                        first = char
                    } else {
                        last = char
                    }
                }
            }
            if(last == nil) {
                last = first
            }
            answer += Int(String("\(first!)\(last!)"))!
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let validNumbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        var answer = 0
        input.forEach { line in
            var first: Character? = nil
            var last: Character? = nil
            
            func assignChar(_ letter: Character){
                if(first == nil){
                    first = letter
                } else {
                    last = letter
                }
            }
            
            var index = 0
            while(index < line.count){
                let char = line[index]
                if(char.isNumber){
                    assignChar(char)
                } else {
                    for (idx, element) in validNumbers.enumerated(){
                        let elementLength = element.count
                        if(
                            index < line.count+1-elementLength &&
                            line[index...(index+elementLength-1)] == element
                        ) {
                            assignChar("\(idx + 1)"[0])
                            break
                        }
                    }
                }
                index += 1
            }
            if(last == nil) {
                last = first
            }
            answer += Int(String("\(first!)\(last!)"))!
        }
        return "\(answer)"
    }
    
    
}
