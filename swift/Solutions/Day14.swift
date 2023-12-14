//
//  Day14.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/12/23.
//

import Foundation

struct Day14: Day {
    func part1Solution(input: [String]) -> String {
        var grid = input.filter({!$0.isEmpty}) .map { Array($0) }
        
        func trickleUp(_ x: Int, _ y: Int){
            if x == 0 { return }
            if grid[x][y] == "O", grid[x-1][y] == "." {
                grid[x][y] = "."
                grid[x-1][y] = "O"
                trickleUp(x-1, y)
            }
        }
        
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if grid[i][j] == "O" {
                    trickleUp(i, j)
                }
            }
        }
        
        var answer = 0
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if grid[i][j] == "O" {
                    answer += (input.filter({!$0.isEmpty}).count - i)
                }
            }
        }
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var grid = input.filter({!$0.isEmpty}) .map { Array($0) }
        
        func trickleUp(_ x: Int, _ y: Int){
            if x == 0 { return }
            if grid[x][y] == "O", grid[x-1][y] == "." {
                grid[x][y] = "."
                grid[x-1][y] = "O"
                trickleUp(x-1, y)
            }
        }
        func trickleLeft(_ x: Int, _ y: Int){
            if y == 0 { return }
            if grid[x][y] == "O", grid[x][y-1] == "." {
                grid[x][y] = "."
                grid[x][y-1] = "O"
                trickleLeft(x, y-1)
            }
        }
        func reaganomics(_ x: Int, _ y: Int){
            if x == grid.count-1 { return }
            if grid[x][y] == "O", grid[x+1][y] == "." {
                grid[x][y] = "."
                grid[x+1][y] = "O"
                reaganomics(x+1, y)
            }
        }
        func trickleRight(_ x: Int, _ y: Int){
            if y == grid[0].count-1 { return }
            if grid[x][y] == "O", grid[x][y+1] == "." {
                grid[x][y] = "."
                grid[x][y+1] = "O"
                trickleRight(x, y+1)
            }
        }
        
        var cache = [String: Int]()
        
        func printGrid(){
            for line in grid {
                print(String(line))
            }
            
            print(" ")
        }
        
        for iteration in 0..<cycleNum {
            for i in 0..<grid.count {
                for j in 0..<grid[0].count {
                    if grid[i][j] == "O" {
                        trickleUp(i, j)
                    }
                }
            }
            for j in 0..<grid.count {
                for i in 0..<grid[0].count {
                    if grid[i][j] == "O" {
                        trickleLeft(i, j)
                    }
                }
            }
            for i in (0..<grid.count).reversed(){
                for j in 0..<grid[0].count {
                    if grid[i][j] == "O" {
                        reaganomics(i, j)
                    }
                }
            }
            for j in (0..<grid.count).reversed() {
                for i in 0..<grid[0].count {
                    if grid[i][j] == "O" {
                        trickleRight(i, j)
                    }
                }
            }
            let endState = String(grid.joined(separator: ""))
            if let prevIteration = cache[endState], (cycleNum - prevIteration ) % ((iteration + 1) - prevIteration) == 0 {
                break
            }
            cache[endState] = iteration + 1
        }
        
        var answer = 0
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if grid[i][j] == "O" {
                    answer += (grid.count - i)
                }
            }
        }
        
        return "\(answer)"
    }
    
    let cycleNum = 1000000000
}
