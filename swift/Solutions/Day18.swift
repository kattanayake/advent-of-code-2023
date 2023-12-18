//
//  Day18.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/17/23.
//

import Foundation

struct Day18 : Day {
    func part1Solution(input: [String]) -> String {
        let instructions = input.filter { !$0.isEmpty }.map { line in
            let lineParts = line.split(separator: " ")
            let dir: Direction
            switch(lineParts[0]){
            case "L": dir = .left
            case "R": dir = .right
            case "U": dir = .up
            default : dir = .down
            }
            return Instruction(
                direction: dir, steps: Int(lineParts[1])!, color: String(lineParts[2]))
        }
        
        var curDir: Direction? = nil
        var isClockwise: Bool? = nil
        var currentCoords = Coordinate(x: 0, y: 0)
        var frontier = [(Coordinate, Direction)]()
        var visited = Set<Coordinate>(arrayLiteral: currentCoords)
        
        for ins in instructions {
            if let curDirection = curDir {
                if isClockwise == nil {
                    if let (_, nextDir) = curDirection.turnRight(currentCoords), nextDir == ins.direction {
                        isClockwise = true
                    }
                    else if let (_, nextDir) = curDirection.turnLeft(currentCoords), nextDir == ins.direction {
                        isClockwise = false
                    } else {
                        isClockwise = false
                        print("We've doubled back!")
                    }
                }
                for _ in 0..<ins.steps {
                    currentCoords = ins.direction.takeStep(currentCoords)!
                    visited.insert(currentCoords)
                    if isClockwise! {
                        frontier.append(ins.direction.turnRight(currentCoords)!)
                    } else {
                        frontier.append(ins.direction.turnLeft(currentCoords)!)
                    }
                }
            } else {
                for _ in 0..<ins.steps {
                    currentCoords = ins.direction.takeStep(currentCoords)!
                    visited.insert(currentCoords)
                }
            }
            curDir = ins.direction
        }
        
        func floodFill(_ cell: Coordinate, _ dir: Direction){
            if visited.contains(cell) {
                return
            }
            visited.insert(cell)
            let nextCell = dir.takeStep(cell)!
            floodFill(nextCell, dir)
            let (left, lDir) = dir.turnLeft(cell)!
            floodFill(left, lDir)
            let(right, rDir) = dir.turnRight(cell)!
            floodFill(right, rDir)
        }
        
        func printDebugMap(){
            let minX = visited.map { $0.x }.min()!
            let maxX = visited.map { $0.x }.max()!
            let minY = visited.map { $0.y }.min()!
            let maxY = visited.map { $0.y }.max()!
            for x in minX ... maxX {
                for y in minY ... maxY {
                    if visited.contains(Coordinate(x:x, y:y)){
                        print("#", terminator: "")
                    } else {
                        print(".", terminator: "")
                    }
                }
                print("")
            }
            print("")
        }
        while !frontier.isEmpty {
            let (insideCell, cellDir) = frontier.removeFirst()
            floodFill(insideCell, cellDir)
        }
        
        return "\(visited.count)"
    }
    
    func part2Solution(input: [String]) -> String {
        let ins = input.filter { !$0.isEmpty }.map { line in
            let color = line.split(separator: " ")[2]
            let direction: Direction
            switch(color[color.count-2]){
            case "0" : direction = .right
            case "1" : direction = .down
            case "2" : direction = .left
            default : direction = .up
            }
            return (Int(String(color[2..<(color.count-2)]), radix: 16)!, direction)
        }
        var vertices = [Coordinate](arrayLiteral: Coordinate(x:0, y:0))
        var prevVertex = vertices[0]
        var perimeter = 0
        
        ins.forEach { (steps, dir) in
            let newEnd = dir.takeUnboundedSteps(steps, prevVertex)
            vertices.append(newEnd)
            prevVertex = newEnd
            perimeter += steps
        }
        
        var area = 0
        for i in 1..<vertices.count {
            let prev = vertices[i - 1]
            let cur = vertices[i]
            area += (cur.x - prev.x) * prev.y
        }
        
        var answer = area + (perimeter / 2) + 1
        return "\(answer)"
    }
    
    struct Instruction {
        let direction: Direction
        let steps: Int
        let color: String
    }
}
