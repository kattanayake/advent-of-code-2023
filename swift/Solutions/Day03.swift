//
//  Part3.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/3/23.
//

import Foundation

struct Day03: Day {
    func part1Solution(input: [String]) -> String {
        
        func isNextToSymbol(_ startX: Int, startY: Int, endY: Int) -> Bool {
            func charIsSymbol(_ char: Character) -> Bool {
                return !char.isNumber && char != "."
            }
            
            if(startX > 0){
                for idx in max(startY-1, 0)...min(input.count-1, endY+1){
                    if charIsSymbol(input[startX-1][idx]) { return true }
                }
            }
            if(startX < input.count-1){
                for idx in max(startY-1, 0)...min(input.count-1, endY+1){
                    if charIsSymbol(input[startX+1][idx]) { return true }
                }
            }
            if(startY > 0){
                if charIsSymbol(input[startX][startY-1]) { return true }
            }
            if(endY < input[0].count-1){
                if charIsSymbol(input[startX][endY+1]) { return true }
            }
            return false
        }
        
        
        var answer = 0
        for (lineIdx, line) in input.enumerated(){
            var startIndex = -1
            for (charIdx, char) in line.enumerated(){
                if(char.isNumber && startIndex == -1){ startIndex = charIdx }
                else if(!char.isNumber && startIndex != -1){
                    if isNextToSymbol(lineIdx, startY: startIndex, endY: charIdx - 1) {
                        answer += Int(line[startIndex...(charIdx-1)])!
                    }
                    startIndex = -1
                }
            }
            
            /// If the last char was also a number
            if(startIndex != -1){
                if isNextToSymbol(lineIdx, startY: startIndex, endY: line.count-1) {
                    answer += Int(line[startIndex...(line.count-1)])!
                }
            }
        }
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        func isNextToSymbol(_ startX: Int, startY: Int, endY: Int) -> [Int]? {
            func charIsSymbol(_ char: Character) -> Bool {
                return char == "*"
            }
            
            if(startX > 0){
                for idx in max(startY-1, 0)...min(input.count-1, endY+1){
                    if charIsSymbol(input[startX-1][idx]) { return [startX-1, idx] }
                }
            }
            if(startX < input.count-1){
                for idx in max(startY-1, 0)...min(input.count-1, endY+1){
                    if charIsSymbol(input[startX+1][idx]) { return [startX+1, idx] }
                }
            }
            if(startY > 0){
                if charIsSymbol(input[startX][startY-1]) { return [startX, startY-1] }
            }
            if(endY < input[0].count-1){
                if charIsSymbol(input[startX][endY+1]) { return [startX, endY+1] }
            }
            return nil
        }
        
        var gearMap = [[Int]:[Int]]() // [x, y]: [numbers near them]
        for (lineIdx, line) in input.enumerated(){
            var startIndex = -1
            for (charIdx, char) in line.enumerated(){
                if(char.isNumber && startIndex == -1){ startIndex = charIdx }
                else if(!char.isNumber && startIndex != -1){
                    if let gear = isNextToSymbol(lineIdx, startY: startIndex, endY: charIdx - 1) {
                        gearMap[gear, default: []].append(Int(line[startIndex...(charIdx-1)])!)
                    }
                    startIndex = -1
                }
            }
            
            /// If the last char was also a number
            if(startIndex != -1){
                if let gear = isNextToSymbol(lineIdx, startY: startIndex, endY: line.count-1) {
                    gearMap[gear, default: []].append(Int(line[startIndex...(line.count-1)])!)
                }
            }
        }
        
        var answer = 0
        gearMap.forEach { gears in
            if(gears.value.count == 2){
                answer += (gears.value[0] * gears.value[1])
            }
        }
        return "\(answer)"
    }
    
    
}
