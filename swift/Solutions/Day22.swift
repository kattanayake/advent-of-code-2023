//
//  Day22.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/21/23.
//

import Foundation

struct Day22: Day {
    
    private func parseInput(input: [String]) -> [Brick] {
        input.filter({!$0.isEmpty}).map { line in
            let lineParts = line.split(separator: "~")
            let startParts = lineParts[0].split(separator: ",").map { Int(String($0))! }
            let endParts = lineParts[1].split(separator: ",").map { Int(String($0))! }
            return Brick(x: startParts[0]...endParts[0], y: startParts[1]...endParts[1], z: startParts[2]...endParts[2])
        }
    }
    
    ///Returns final brick positions, num bricks dropped, num load bearing bricks
    private func drop(bricks: [Brick]) -> ([Brick], [Int]) {
        var grid = [Coordinate3D: Int]()
        var sortedBricks = bricks.sorted(by: { a, b in a.z.lowerBound < b.z.lowerBound })
        var bricksDropped = [Int]()
        for (idx, brick) in sortedBricks.enumerated() {
            // If this is on the ground, immediately add it to the grid
            if brick.z.lowerBound == 1 {
                for xIdx in brick.x {
                    for yIdx in brick.y {
                        for zIdx in brick.z {
                            grid[Coordinate3D(x: xIdx, y: yIdx, z: zIdx)] = idx
                        }
                    }
                }
            } else { // Otherwise drop it as low as we can
                var obstructed = false
                var currentZ = brick.z.lowerBound
                repeat {
                    for xIdx in brick.x {
                        for yIdx in brick.y {
                            if grid[Coordinate3D(x: xIdx, y: yIdx, z: currentZ-1)] != nil {
                                obstructed = true
                            }
                        }
                    }
                    if !obstructed {
                        currentZ -= 1
                    }
                } while currentZ > 1 && !obstructed
                // Did this actually drop?
                let levelsDropped = brick.z.lowerBound - currentZ
                if levelsDropped > 0 {
                    bricksDropped.append(idx)
                }
                // Add it to the grid
                for xIdx in brick.x {
                    for yIdx in brick.y {
                        for zIdx in brick.z {
                            grid[Coordinate3D(x: xIdx, y: yIdx, z: zIdx - levelsDropped)] = idx
                        }
                    }
                }
                // Update list with new position
                sortedBricks[idx] = Brick(x: brick.x, y: brick.y, z: (brick.z.lowerBound-levelsDropped)...(brick.z.upperBound - levelsDropped))
            }
        }
        
        for (idx, brick) in sortedBricks.enumerated() {
            var bearers = Set<Int>()
            for xIdx in brick.x {
                for yIdx in brick.y {
                    for zIdx in brick.z {
                        if let bearerIdx = grid[Coordinate3D(x: xIdx, y: yIdx, z: zIdx-1)], bearerIdx != idx {
                            bearers.insert(bearerIdx)
                        }
                    }
                }
            }
            // If this brick is being held up by exactly one brick, then that one is load bearing
            if bearers.count == 1 {
                sortedBricks[bearers.first!].isLoadBearing = true
            }
        }
        return (sortedBricks, bricksDropped)
    }
    
    func part1Solution(input: [String]) -> String {
        let answer = drop(bricks: parseInput(input: input)).0.filter { !$0.isLoadBearing }.count
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let (droppedBricks, _) = drop(bricks: parseInput(input: input))
        var answer = 0
        for i in 0..<droppedBricks.count {
            var copy = droppedBricks
            copy.remove(at: i)
            answer += drop(bricks: copy).1.count
        }
        return "\(answer)"
    }
    
    struct Brick {
        let x: ClosedRange<Int>
        let y: ClosedRange<Int>
        let z: ClosedRange<Int>
        var isLoadBearing = false
    }
    
    struct Coordinate3D: Hashable {
        let x:Int
        let y:Int
        let z:Int
    }
}

