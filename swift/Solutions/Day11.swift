//
//  Day11.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/10/23.
//

import Foundation

struct Day11: Day {
    func part1Solution(input: [String]) -> String {
        var parsedInput = [String]()
        
        // Adding extra rows
        var colGalaxyPresence = [Bool](repeating: false, count: input.count)
        for row in input {
            var rowHasGalaxy = false
            for (colIdx, cell) in row.enumerated(){
                if cell == "#" {
                    rowHasGalaxy = true
                    colGalaxyPresence[colIdx] = true
                }
            }
            parsedInput.append(row)
            if !rowHasGalaxy {
                parsedInput.append(row)
            }
        }
        
        var offset = 0
        
        // Adding extra columns
        for colIdx in 0..<input[0].count {
            if !colGalaxyPresence[colIdx]{
                for rowIdx in 0..<parsedInput.count {
                    var row = parsedInput[rowIdx]
                    row.insert(".", at: row.index(row.startIndex, offsetBy: colIdx + offset))
                    parsedInput[rowIdx] = row
                }
                offset += 1
            }
        }
        
        // Collecting galaxies
        var galaxies = [[Int]]()
        for (rowIdx, row) in parsedInput.enumerated(){
            for (colIdx, cell) in row.enumerated(){
                if cell == "#" {
                    galaxies.append([rowIdx, colIdx])
                }
            }
        }
        
        var answer = [Int]()
        for i in 0..<galaxies.count {
            let first = galaxies[i]
            for j in (i+1)..<galaxies.count {
                let second = galaxies[j]
                answer.append(abs(second[0] - first[0]) + abs(second[1] - first[1]))
            }
        }
        
        return "\(answer.reduce(0, +))"
    }
    
    func part2Solution(input: [String]) -> String {
        var galaxies = [[Int]]()
        var colGalaxyPresence = [Bool](repeating: false, count: input[0].count)
        var rowGalaxyPresence = [Bool](repeating: false, count: input.count)
        for (rowIdx, row) in input.enumerated(){
            for (colIdx, cell) in row.enumerated(){
                if cell == "#" {
                    colGalaxyPresence[colIdx] = true
                    rowGalaxyPresence[rowIdx] = true
                    galaxies.append([rowIdx, colIdx])
                }
            }
        }
        
        var expandedGalaxies = galaxies.map { $0 }
        for i in 0..<input.count {
            if !rowGalaxyPresence[i]{
                for (galaxyIdx, galaxy) in galaxies.enumerated() {
                    if galaxy[0] > i {
                        expandedGalaxies[galaxyIdx][0] += (expansionSize - 1)
                    }
                }
            }
        }
        
        for j in 0..<input[0].count {
            if !colGalaxyPresence[j]{
                for (galaxyIdx, galaxy) in galaxies.enumerated() {
                    if galaxy[1] > j {
                        expandedGalaxies[galaxyIdx][1] += (expansionSize - 1)
                    }
                }
            }
        }
        
        var answer = [Int]()
        for i in 0..<expandedGalaxies.count {
            let first = expandedGalaxies[i]
            for j in (i+1)..<expandedGalaxies.count {
                let second = expandedGalaxies[j]
                answer.append(abs(second[0] - first[0]) + abs(second[1] - first[1]))
            }
        }
        
        return "\(answer.reduce(0, +))"
    }
    
    let expansionSize = 1000000
}
