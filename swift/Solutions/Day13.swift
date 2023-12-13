//
//  Day13.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/11/23.
//

import Foundation

struct Day13: Day {
    func part1Solution(input: [String]) -> String {
        var currentRows = [String]()
        
        func confirmIsMirror(_ index: Int, _ source:[String]) -> Bool {
            var forwardIndex = index
            var backwardIndex = index-1
            while backwardIndex >= 0, forwardIndex < source.count {
                if source[forwardIndex] != source[backwardIndex] {
                    return false
                }
                forwardIndex += 1
                backwardIndex -= 1
            }
            return true
        }
        
        
        var answer = 0
        
        input.forEach { line in
            if line.isEmpty {
                // Validate rows
                for i in 1..<currentRows.count {
                    if confirmIsMirror(i, currentRows) {
                        answer += i * 100
                        break
                    }
                }
                
                // Validate columns
                var columns = [[Character]](repeating: [], count: currentRows[0].count)
                for i in 0..<currentRows[0].count {
                    for j in 0..<currentRows.count {
                        columns[i].append(currentRows[j][i])
                    }
                }
                
                let columnArray = columns.map { String($0) }
                for i in 1..<columns.count {
                    if(confirmIsMirror(i, columnArray)){
                        answer += i
                        break
                    }
                }
                
                currentRows.removeAll()
                
            } else {
                currentRows.append(line)
            }
            
        }
        return "\(answer)"
    }
    
    func isOneOff(_ a: String, _ b: String) -> Bool {
        var differences = 0
        for i in 0..<a.count {
            if a[i] != b[i]{
                differences += 1
                if differences > 1 {
                    return false
                }
            }
        }
        return differences == 1
    }
    
    
    
    func part2Solution(input: [String]) -> String {
        var currentRows = [String]()
        
        func confirmIsMirror(_ source:[String], _ forwardIndex: Int, _ backwardsIndex: Int, _ guessUsedUp: Bool) -> Bool {
            if !(backwardsIndex >= 0 && forwardIndex < source.count) {
                return guessUsedUp
            }
            if source[forwardIndex] == source[backwardsIndex] {
                return confirmIsMirror(source, forwardIndex + 1, backwardsIndex - 1, guessUsedUp)
            } else if !guessUsedUp, isOneOff(source[forwardIndex],  source[backwardsIndex]){
                return confirmIsMirror(source, forwardIndex + 1, backwardsIndex - 1, true)
            }
            return false
        }
        
        
        var answer = 0
        
        input.forEach { line in
            if line.isEmpty {
                // Validate rows
                for i in 1..<currentRows.count {
                    if confirmIsMirror(currentRows, i, i - 1, false) {
                        answer += i * 100
                        break
                    }
                }
                
                // Validate columns
                var columns = [[Character]](repeating: [], count: currentRows[0].count)
                for i in 0..<currentRows[0].count {
                    for j in 0..<currentRows.count {
                        columns[i].append(currentRows[j][i])
                    }
                }
                
                let columnArray = columns.map { String($0) }
                for i in 1..<columns.count {
                    if(confirmIsMirror(columnArray, i, i - 1, false)){
                        answer += i
                        break
                    }
                }
                
                currentRows.removeAll()
                
            } else {
                currentRows.append(line)
            }
            
        }
        return "\(answer)"
    }
    
    
}
