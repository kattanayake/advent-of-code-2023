//
//  Day16.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/14/23.
//

import Foundation

struct Day16: Day {
    
    func part1Solution(input: [String]) -> String {
        let grid = input[0..<input.count-1].map {Array($0)}
        var isEnergized = [[Set<Int>]](repeating: [Set<Int>](repeating: Set(), count: grid[0].count), count: grid.count)
        var answer = 0
        
        func printGrid() -> String {
            var ans = ""
            for (lineidx, line) in grid.enumerated(){
                for (charIdx, _) in line.enumerated(){
                    switch(isEnergized[lineidx][charIdx].first){
                    case 0: ans += "^"
                    case 1: ans += ">"
                    case 2: ans += "v"
                    case 3: ans += "<"
                    default: ans += "."
                    }
                }
                ans += "\n"
            }
            print(ans)
            print("")
            return ans
        }
        
        func propogateBeam(_ x:Int, _ y:Int, _ direction: Int){
//            let gridState = printGrid()
            if(x < 0 || x >= grid.count || y < 0 || y >= grid[0].count){
                return
            }
            if isEnergized[x][y].isEmpty {
                answer += 1
            } else if isEnergized[x][y].contains(direction){
                return
            }
            
            isEnergized[x][y].insert(direction)
            
            switch(grid[x][y]){
            case "-":
                switch(direction){
                case 0, 2:
                    propogateBeam(x, y+1, 1)
                    propogateBeam(x, y-1, 3)
                case 1:
                    propogateBeam(x, y+1, 1)
                default:
                    propogateBeam(x, y-1, 3)
                }
            case "|":
                switch(direction){
                case 1, 3:
                    propogateBeam(x-1, y, 0)
                    propogateBeam(x+1, y, 2)
                case 0:
                    propogateBeam(x-1, y, 0)
                default:
                    propogateBeam(x+1, y, 2)
                }
            case "\\":
                switch(direction){
                case 0:
                    propogateBeam(x, y-1, 3)
                case 1:
                    propogateBeam(x+1, y, 2)
                case 2:
                    propogateBeam(x, y+1, 1)
                default:
                    propogateBeam(x-1, y, 0)
                }
            case "/":
                switch(direction){
                case 0:
                    propogateBeam(x, y+1, 1)
                case 1:
                    propogateBeam(x-1, y, 0)
                case 2:
                    propogateBeam(x, y-1, 3)
                default:
                    propogateBeam(x+1, y, 2)
                }
            default:
                switch(direction){
                case 0:
                    propogateBeam(x-1, y, 0)
                case 1:
                    propogateBeam(x, y+1, 1)
                case 2:
                    propogateBeam(x+1, y, 2)
                default:
                    propogateBeam(x, y-1, 3)
                }
            }
        }
        
        propogateBeam(0,0,1)
        
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let grid = input[0..<input.count-1].map {Array($0)}
        var isEnergized = [[Set<Int>]](repeating: [Set<Int>](repeating: Set(), count: grid[0].count), count: grid.count)
        var answer = 0
        
        func printGrid() -> String {
            var ans = ""
            for (lineidx, line) in grid.enumerated(){
                for (charIdx, _) in line.enumerated(){
                    switch(isEnergized[lineidx][charIdx].first){
                    case 0: ans += "^"
                    case 1: ans += ">"
                    case 2: ans += "v"
                    case 3: ans += "<"
                    default: ans += "."
                    }
                }
                ans += "\n"
            }
            print(ans)
            print("")
            return ans
        }
        
        func propogateBeam(_ x:Int, _ y:Int, _ direction: Int){
//            let gridState = printGrid()
            if(x < 0 || x >= grid.count || y < 0 || y >= grid[0].count){
                return
            }
            if isEnergized[x][y].isEmpty {
                answer += 1
            } else if isEnergized[x][y].contains(direction){
                return
            }
            
            isEnergized[x][y].insert(direction)
            
            switch(grid[x][y]){
            case "-":
                switch(direction){
                case 0, 2:
                    propogateBeam(x, y+1, 1)
                    propogateBeam(x, y-1, 3)
                case 1:
                    propogateBeam(x, y+1, 1)
                default:
                    propogateBeam(x, y-1, 3)
                }
            case "|":
                switch(direction){
                case 1, 3:
                    propogateBeam(x-1, y, 0)
                    propogateBeam(x+1, y, 2)
                case 0:
                    propogateBeam(x-1, y, 0)
                default:
                    propogateBeam(x+1, y, 2)
                }
            case "\\":
                switch(direction){
                case 0:
                    propogateBeam(x, y-1, 3)
                case 1:
                    propogateBeam(x+1, y, 2)
                case 2:
                    propogateBeam(x, y+1, 1)
                default:
                    propogateBeam(x-1, y, 0)
                }
            case "/":
                switch(direction){
                case 0:
                    propogateBeam(x, y+1, 1)
                case 1:
                    propogateBeam(x-1, y, 0)
                case 2:
                    propogateBeam(x, y-1, 3)
                default:
                    propogateBeam(x+1, y, 2)
                }
            default:
                switch(direction){
                case 0:
                    propogateBeam(x-1, y, 0)
                case 1:
                    propogateBeam(x, y+1, 1)
                case 2:
                    propogateBeam(x+1, y, 2)
                default:
                    propogateBeam(x, y-1, 3)
                }
            }
        }
        
        var curMax = 0
        
        func updateMax(){
            curMax = max(curMax, answer)
            isEnergized = [[Set<Int>]](repeating: [Set<Int>](repeating: Set(), count: grid[0].count), count: grid.count)
            answer = 0
        }
        
        
        for startX in 0..<grid.count {
            for startY in 0..<grid[0].count {
                if(startX == 0){
                    propogateBeam(startX, startY, 2)
                    updateMax()
                }
                if(startY == 0){
                    propogateBeam(startX, startY, 1)
                    updateMax()
                }
                if(startX == grid.count-1){
                    propogateBeam(startX, startY, 0)
                    updateMax()
                }
                if(startY == grid[0].count-1){
                    propogateBeam(startX, startY, 3)
                    updateMax()
                }
            }
        }
        
        return "\(curMax)"
    }
    
    
}
