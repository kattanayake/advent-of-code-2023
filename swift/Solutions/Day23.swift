//
//  Day23.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/22/23.
//

import Foundation

struct Day23: Day {
    
    private func parseInput(input: [String]) -> [[Character]] {
        input.filter({!$0.isEmpty}).map { Array($0) }
    }
    
    private func debugPrintGrid(_ grid: [[Character]], _ path: Set<Coordinate>){
        for xIdx in 0..<grid.count {
            for yIdx in 0..<grid[0].count {
                if path.contains(Coordinate((xIdx, yIdx))) {
                    if grid[xIdx][yIdx] == "#" {
                        print("X", terminator: "")
                    } else {
                        print("O", terminator: "")
                    }
                } else {
                    print(grid[xIdx][yIdx], terminator: "")
                }
            }
            print("")
        }
        print("")
    }
    
    func explore(cell: Coordinate, path: Set<Coordinate>, grid: [[Character]], endY: Int) -> Int? {
        if cell.x == grid.count - 1, cell.y ==  endY {
//            debugPrintGrid(grid, path)
            return path.count
        }
        
        var longest = 0
        [Direction.up.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
        Direction.down.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
        Direction.left.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
         Direction.right.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1)].forEach {
            if let neighbour = $0 , grid[neighbour.x][neighbour.y] != "#", !path.contains(neighbour) {
                var nextPath = path
                nextPath.insert(neighbour)
                var nextNeighbour: Coordinate? = nil
                if grid[neighbour.x][neighbour.y] == ">" {
                    nextNeighbour = Direction.right.takeStep(neighbour, maxX: grid.count - 1, maxY: grid[0].count - 1)
                } else if grid[neighbour.x][neighbour.y] == "<" {
                    nextNeighbour = Direction.left.takeStep(neighbour, maxX: grid.count - 1, maxY: grid[0].count - 1)
                } else if grid[neighbour.x][neighbour.y] == "v" {
                    nextNeighbour = Direction.down.takeStep(neighbour, maxX: grid.count - 1, maxY: grid[0].count - 1)
                } else if grid[neighbour.x][neighbour.y] == "^" {
                    nextNeighbour = Direction.up.takeStep(neighbour, maxX: grid.count - 1, maxY: grid[0].count - 1)
                }
                
                if let nextNeighbour {
                    if grid[nextNeighbour.x][nextNeighbour.y] == ".", !path.contains(nextNeighbour) {
                        nextPath.insert(nextNeighbour)
                        if let result = explore(cell: nextNeighbour, path: nextPath, grid: grid, endY: endY){
                            longest = max(longest, result)
                        }
                    }
                } else  {
                    if let result = explore(cell: neighbour, path: nextPath, grid: grid, endY: endY){
                        longest = max(longest, result)
                    }
                }
            }
        }
        
        return longest == 0 ? nil : longest
    }
    
    
    func part1Solution(input: [String]) -> String {
        let grid = parseInput(input: input)
        let startY = Coordinate(x: 0, y:grid[0].firstIndex(of: ".")!)
        let endY = grid.last!.firstIndex(of: ".")!
        
        let answer = explore(cell: startY, path: Set(arrayLiteral: startY), grid: grid, endY: endY)! - 1
        return "\(answer)"
    }
    
    private func debugPrintGrid(_ grid: [[Character]], _ path: [[Int]]){
        for xIdx in 0..<grid.count {
            for yIdx in 0..<grid[0].count {
                if path[xIdx][yIdx] == 1 {
                    if grid[xIdx][yIdx] == "#" {
                        print("X", terminator: "")
                    } else {
                        print("O", terminator: "")
                    }
                } else {
                    print(grid[xIdx][yIdx], terminator: "")
                }
            }
            print("")
        }
        print("")
    }
    
    func exploreSimple(cell: Coordinate, path: inout [[Int]], grid: [[Character]], endY: Int, curMax: inout Int) {
        func generateNeighbours(for:Coordinate) -> [Coordinate] {
            [Direction.up.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
            Direction.down.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
            Direction.left.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1),
             Direction.right.takeStep(cell, maxX: grid.count - 1, maxY: grid[0].count - 1)].compactMap {
                if let neighbour = $0 , grid[neighbour.x][neighbour.y] != "#", path[neighbour.x][neighbour.y] == 0 {
                    return $0
                } else {
                    let nothing: Coordinate? = nil
                    return nothing
                }
            }
        }
        
        if cell.x == grid.count - 1, cell.y ==  endY {
            let pathLength = path.map { $0.reduce(0, +) }.reduce(0, +) - 1
            let newMax = max(pathLength, curMax)
            if newMax != curMax {
                print(newMax)
                curMax = newMax
            }
            return
        }
        
        generateNeighbours(for: cell).forEach { neighbour in
            path[neighbour.x][neighbour.y] = 1
            exploreSimple(cell: neighbour, path: &path, grid: grid, endY: endY, curMax: &curMax)
            path[neighbour.x][neighbour.y] = 0
        }
    }
    
    func part2Solution(input: [String]) -> String {
        let grid = parseInput(input: input.map {line in String(line.map { "<>^v".contains($0) ? "." : $0 }) })
        let startY = Coordinate(x: 0, y:grid[0].firstIndex(of: ".")!)
        let endY = grid.last!.firstIndex(of: ".")!
        
        var max = 0
        var path =  [[Int]](repeating: [Int](repeating: 0, count: grid[0].count), count: grid.count)
        path[0][startY.y] = 1
        
        exploreSimple(cell: startY, path: &path, grid: grid, endY: endY, curMax: &max)
        return "\(max)"
    }
    
    
}

extension String {
    func indexOf(_ char: Character) -> Int {
        self.distance(from: self.startIndex, to: self.firstIndex(of: char)!)
    }
}
