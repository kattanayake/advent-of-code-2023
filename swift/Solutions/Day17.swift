//
//  Day17.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/16/23.
//

import Foundation
import Collections

struct Day17: Day {
    func part1Solution(input: [String]) -> String {
        let grid = input[0..<input.count-1].map { line in line.map { Int(String($0))! } }
        
        func isEnd(_ cell: GridCell) -> Bool {
            cell.coordinates.x == grid.count-1 && cell.coordinates.y == grid[0].count-1
        }
        
        func generateNeighbours(_ cell: GridCell) -> [GridCell]{
            var neighbours = [GridCell]()
            
            if cell.stepsInDirection < 3 {
                if let newCoords = cell.direction.takeStep(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                    neighbours.append(GridCell(
                        coordinates: newCoords,
                        direction: cell.direction,
                        stepsInDirection: cell.stepsInDirection + 1
                    ))
                }
            }
            if let (newCoords, newDir) = cell.direction.turnLeft(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                neighbours.append(GridCell(
                    coordinates: newCoords,
                    direction: newDir,
                    stepsInDirection: 1
                ))
            }
            if let (newCoords, newDir) = cell.direction.turnRight(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                neighbours.append(GridCell(
                    coordinates: newCoords,
                    direction: newDir,
                    stepsInDirection: 1
                ))
            }
            return neighbours
        }
        
        let answer = A_Star(
            start: GridCell(coordinates: Coordinate(x: 0, y:0), direction: .right, stepsInDirection: 0),
            isEnd: isEnd,
            neighbours: generateNeighbours,
            cost: {_, dest in grid[dest.coordinates.x][dest.coordinates.y]}
        )
        
        var route: String = ""
        answer.getPath().forEach {
            route += "(\($0.coordinates.x), \($0.coordinates.y)) ->"
        }
        
        return "\(answer.getScore()!)"
    }
    
    func part2Solution(input: [String]) -> String {
        let grid = input[0..<input.count-1].map { line in line.map { Int(String($0))! } }
        
        func isEnd(_ cell: GridCell) -> Bool {
            cell.coordinates.x == grid.count-1 &&
            cell.coordinates.y == grid[0].count-1 &&
            cell.stepsInDirection > 3 &&
            cell.stepsInDirection < 10
        }
        
        func generateNeighbours(_ cell: GridCell) -> [GridCell]{
            var neighbours = [GridCell]()
            
            if cell.stepsInDirection < 10 {
                if let newCoords = cell.direction.takeStep(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                    neighbours.append(GridCell(
                        coordinates: newCoords,
                        direction: cell.direction,
                        stepsInDirection: cell.stepsInDirection + 1
                    ))
                }
            }
            if cell.stepsInDirection > 3, let (newCoords, newDir) = cell.direction.turnLeft(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                neighbours.append(GridCell(
                    coordinates: newCoords,
                    direction: newDir,
                    stepsInDirection: 1
                ))
            }
            if cell.stepsInDirection > 3, let (newCoords, newDir) = cell.direction.turnRight(cell.coordinates, maxX: grid.count-1, maxY: grid[0].count-1) {
                neighbours.append(GridCell(
                    coordinates: newCoords,
                    direction: newDir,
                    stepsInDirection: 1
                ))
            }
            return neighbours
        }
        
        let answer0 = A_Star(
            start: GridCell(coordinates: Coordinate(x: 0, y:0), direction: .right, stepsInDirection: 0),
            isEnd: isEnd,
            neighbours: generateNeighbours,
            cost: {_, dest in grid[dest.coordinates.x][dest.coordinates.y]}
        )
        let answer1 = A_Star(
            start: GridCell(coordinates: Coordinate(x: 0, y:0), direction: .down, stepsInDirection: 0),
            isEnd: isEnd,
            neighbours: generateNeighbours,
            cost: {_, dest in grid[dest.coordinates.x][dest.coordinates.y]}
        )
        
        return "\(min(answer0.getScore()!, answer1.getScore()!))"
    }
    
    struct GridCell: Hashable {
        let coordinates: Coordinate
        let direction: Direction
        let stepsInDirection: Int
    }
}
        
/// 1261 is too Low
/// 1286 is too high
