//
//  Day10.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/8/23.
//

import Foundation

struct Day10: Day {
    func part1Solution(input: [String]) -> String {
        let (parsedGrid, (startX, startY)) = parseGrid(input: input)
        let answer = traverse(grid: parsedGrid, startX: startX, startY: startY)
        return "\(answer)"
    }
    
    private func traverse(grid: [[GridCell]], startX: Int, startY: Int) -> Int{
        var (forwardX, forwardY) = (startX, startY)
        var (backwardX, backwardY) = (startX, startY)
        /// 0: North, 1: East, 2: South, 3: West
        var forwardDir: Int
        var backwardDir: Int
        switch(grid[startX][startY]){
        case .north_south:
            forwardDir = 2
            backwardDir = 0
        case .east_west:
            forwardDir = 3
            backwardDir = 1
        case .north_west:
            forwardDir = 3
            backwardDir = 0
        case .north_east:
            forwardDir = 1
            backwardDir = 0
        case .south_west:
            forwardDir = 2
            backwardDir = 3
        default:
            forwardDir = 2
            backwardDir = 1
        }
        
        var steps = 0
        
        func takeStep(cellX: Int, cellY: Int, direction: Int) -> (Int, Int, Int){
            var nextX = cellX
            var nextY = cellY
            
            switch(direction){
            case 0 : nextX -= 1
            case 1 : nextY += 1
            case 2 : nextX += 1
            default: nextY -= 1
            }
            
            var nextDirection = 0
            
            switch(grid[nextX][nextY]){
            case .north_west:
                if direction == 1 { nextDirection = 0 } else { nextDirection = 3 }
            case .north_east:
                if direction == 3 { nextDirection = 0 } else { nextDirection = 1 }
            case .south_west:
                if direction == 1 { nextDirection = 2 } else { nextDirection = 3 }
            case .south_east:
                if direction == 3 { nextDirection = 2 } else { nextDirection = 1 }
            default: nextDirection = direction
            }
            
            return (nextX, nextY, nextDirection)
        }
        
        repeat {
            (forwardX, forwardY, forwardDir) = takeStep(cellX: forwardX, cellY: forwardY, direction: forwardDir)
            (backwardX, backwardY, backwardDir) = takeStep(cellX: backwardX, cellY: backwardY, direction: backwardDir)
            steps += 1
        } while (forwardX != backwardX) || (forwardY != backwardY)
        return steps
    }
    
    func part2Solution(input: [String]) -> String {
        var (parsedGrid, (startX, startY)) = parseGrid(input: input)
        traverseAndCleanUp(grid: &parsedGrid, startX: startX, startY: startY)
        var highResGrid = increaseResolution(parsedGrid)
        
        var explored = [[Int]](repeating: [Int](repeating: 0, count: highResGrid[0].count), count: highResGrid.count)
        var freeSquares = [[Int]]()
        
        // Setting up perimeter of freedom
        for xIdx in 0..<highResGrid.count {
            if highResGrid[xIdx][0] == .ground {
                highResGrid[xIdx][0] = .unblocked
                freeSquares.append([xIdx, 0])
            }
            if highResGrid[xIdx][highResGrid.count-1] == .ground {
                highResGrid[xIdx][highResGrid.count-1] = .unblocked
                freeSquares.append([xIdx, highResGrid.count-1])
            }
        }
        
        for yIdx in 1..<highResGrid.count-1 {
            if highResGrid[0][yIdx] == .ground {
                highResGrid[0][yIdx] = .unblocked
                freeSquares.append([0, yIdx])
            }
            if highResGrid[highResGrid.count-1][yIdx] == .ground {
                highResGrid[highResGrid.count-1][yIdx] = .unblocked
                freeSquares.append([highResGrid.count-1, yIdx])
            }
        }
        
        while(!freeSquares.isEmpty){
            let next = freeSquares[0]
            let cellX = next[0]
            let cellY = next[1]
            freeSquares.remove(at: 0)
            if cellX > 0 {
                if spreadFreedom(grid: &highResGrid, explored: &explored, cellX: cellX-1, cellY: cellY){
                    freeSquares.append([cellX-1, cellY])
                }
            }
            if cellX < highResGrid.count - 1 {
                if spreadFreedom(grid: &highResGrid, explored: &explored, cellX: cellX+1, cellY: cellY){
                    freeSquares.append([cellX+1, cellY])
                }
            }
            if cellY > 0 {
                if spreadFreedom(grid: &highResGrid, explored: &explored, cellX: cellX, cellY: cellY-1){
                    freeSquares.append([cellX, cellY-1])
                }
            }
            if cellY < highResGrid[0].count - 1 {
                if spreadFreedom(grid: &highResGrid, explored: &explored, cellX: cellX, cellY: cellY+1){
                    freeSquares.append([cellX, cellY+1])
                }
            }
        }
        
        var answer = 0
        for xIdx in 0..<highResGrid.count {
            for yIdx in 0..<highResGrid[0].count {
                if xIdx % 2 == 0, yIdx % 2 == 0, highResGrid[xIdx][yIdx] == .ground {
                    answer += 1
                }
            }
        }
        return "\(answer)"
    }
    
    // Returns true if there's a way out
    private func spreadFreedom(grid: inout [[GridCell]], explored: inout [[Int]], cellX: Int, cellY: Int) -> Bool {
        // If it's not ground, then it is blocked
        if explored[cellX][cellY] == 1 {
            return false
        }
        explored[cellX][cellY] = 1
        if grid[cellX][cellY] != .ground{
            return false
        }
        grid[cellX][cellY] = .unblocked
        return true
    }
    
    private func traverseAndCleanUp(grid: inout [[GridCell]], startX: Int, startY: Int){
        var (forwardX, forwardY) = (startX, startY)
        var (backwardX, backwardY) = (startX, startY)
        /// 0: North, 1: East, 2: South, 3: West
        var forwardDir: Int
        var backwardDir: Int
        switch(grid[startX][startY]){
        case .north_south:
            forwardDir = 2
            backwardDir = 0
        case .east_west:
            forwardDir = 3
            backwardDir = 1
        case .north_west:
            forwardDir = 3
            backwardDir = 0
        case .north_east:
            forwardDir = 1
            backwardDir = 0
        case .south_west:
            forwardDir = 2
            backwardDir = 3
        default:
            forwardDir = 2
            backwardDir = 1
        }
    
        var pathCells = [[Int]]()
        pathCells.append([startX, startY])
        
        func takeStep(cellX: Int, cellY: Int, direction: Int) -> (Int, Int, Int){
            var nextX = cellX
            var nextY = cellY
            
            switch(direction){
            case 0 : nextX -= 1
            case 1 : nextY += 1
            case 2 : nextX += 1
            default: nextY -= 1
            }
            
            var nextDirection = 0
            
            switch(grid[nextX][nextY]){
            case .north_west:
                if direction == 1 { nextDirection = 0 } else { nextDirection = 3 }
            case .north_east:
                if direction == 3 { nextDirection = 0 } else { nextDirection = 1 }
            case .south_west:
                if direction == 1 { nextDirection = 2 } else { nextDirection = 3 }
            case .south_east:
                if direction == 3 { nextDirection = 2 } else { nextDirection = 1 }
            default: nextDirection = direction
            }
            
            return (nextX, nextY, nextDirection)
        }
        
        repeat {
            // Go forward
            (forwardX, forwardY, forwardDir) = takeStep(cellX: forwardX, cellY: forwardY, direction: forwardDir)
            (backwardX, backwardY, backwardDir) = takeStep(cellX: backwardX, cellY: backwardY, direction: backwardDir)
            pathCells.append([forwardX, forwardY])
            pathCells.append([backwardX, backwardY])
        } while (forwardX != backwardX) || (forwardY != backwardY)
        
        let pathCellsSet = Set(pathCells)
        
        // Cleaning up non-relevant pipe pieces
        for idx in 0..<grid.count {
            for idy in 0..<grid[0].count {
                if !pathCellsSet.contains([idx, idy]) {
                    grid[idx][idy] = .ground
                }
            }
        }
    }
    
    private func parseGrid(input:[String]) -> ([[GridCell]], (Int, Int)) {
        var startX = 0
        var startY = 0
        
        var parsedGrid = [[GridCell]]()
        for (lineIdx, line) in input.enumerated() {
            var parsedLine = [GridCell]()
            for(charIdx, char) in line.enumerated() {
                if char == "S" {
                    startX = lineIdx
                    startY = charIdx
                }
                parsedLine.append(GridCell.fromChar(char: char))
            }
            parsedGrid.append(parsedLine)
        }
        
        // Replacing start cell with correct element
        // Checking for north-east and north-west connections
        let above: GridCell?
        let below: GridCell?
        let left: GridCell?
        let right: GridCell?
        if(startX > 0){ above = parsedGrid[startX-1][startY]} else { above = nil }
        if(startX < input.count - 1){ below = parsedGrid[startX+1][startY]} else { below = nil }
        if(startY > 0){ left = parsedGrid[startX][startY-1]} else { left = nil }
        if(startY < input.count - 1){ right = parsedGrid[startX][startY+1]} else { right = nil }
        
        if let above, Set([.north_south, .south_east, .south_west]).contains(above){
            if let left,  Set([.east_west, .north_east, .south_east]).contains(left){
                parsedGrid[startX][startY] = .north_west
            } else if let right, Set([.east_west, .north_west, .south_west]).contains(right){
                parsedGrid[startX][startY] = .north_east
            } else {
                parsedGrid[startX][startY] = .north_south
            }
        } else if let below, Set([.north_south, .north_east, .north_west]).contains(below){
            if let left, Set([.east_west, .north_east, .south_east]).contains(left){
                parsedGrid[startX][startY] = .south_west
            } else if let right, Set([.east_west, .north_west, .south_west]).contains(right){
                parsedGrid[startX][startY] = .south_east
            } else {
                parsedGrid[startX][startY] = .north_south
            }
        } else {
            parsedGrid[startX][startY] = GridCell.east_west
        }
        
        return (parsedGrid, (startX, startY))
    }
    
    private func increaseResolution(_ grid: [[GridCell]]) -> [[GridCell]]{
        var highResolutionGrid = [[GridCell]]()
        for line in grid {
            var newLine = [GridCell]()
            var nextLine = [GridCell]()
            for cell in line {
                newLine.append(cell)
                if Set([.east_west, .north_east, .south_east]).contains(cell) {
                    newLine.append(.east_west)
                } else {
                    newLine.append(.ground)
                }
                if Set([.north_south, .south_east, .south_west]).contains(cell) {
                    nextLine.append(.north_south)
                } else {
                    nextLine.append(.ground)
                }
                nextLine.append(.ground)
            }
            highResolutionGrid.append(newLine)
            highResolutionGrid.append(nextLine)
        }
        return highResolutionGrid
    }
    
    private func printGrid(_ grid: [[GridCell]]){
        for line in grid {
            for cell in line {
                print(cell.toChar(), terminator: "")
            }
            print("")
        }
    }
}

enum GridCell{
    case north_south
    case east_west
    case north_west
    case north_east
    case south_west
    case south_east
    case ground
    case blocked
    case unblocked
    
    static func fromChar(char: Character) -> GridCell {
        switch(char){
        case "|": return north_south
        case "-": return east_west
        case "L": return north_east
        case "J": return north_west
        case "7": return south_west
        case "F": return south_east
        default : return ground
        }
    }
    
    func toChar() -> Character {
        switch(self){
        case .north_south: return "|"
        case .east_west: return "-"
        case .north_west: return "J"
        case .north_east: return "L"
        case .south_west: return "7"
        case .south_east: return "F"
        case .ground: return "."
        case .blocked: return "O"
        case .unblocked: return "X"
        }
    }
}
