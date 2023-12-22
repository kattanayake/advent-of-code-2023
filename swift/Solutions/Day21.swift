//
//  Day21.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/20/23.
//

import Foundation

struct Day21: Day {
    
    private func parseInput(input: [String]) -> ((Int, Int), [[Character]]) {
        var startX = 0
        var startY = 0
        let grid = input.filter({!$0.isEmpty}).enumerated().map { (xIndex, line) in
            // TODO make this a util extension
            if let i = line.firstIndex(of: "S") {
                startY = line.distance(from: line.startIndex, to: i)
                startX = xIndex
            }
            return Array(line)
        }
        return ((startX, startY), grid)
    }
    
    private func explore(grid: [[Character]], startX: Int, startY: Int, steps: Int) -> Int {
        var frontier = Set<Coordinate>(arrayLiteral: Coordinate(x:startX, y:startY))
        var nextFrontier = Set<Coordinate>()
        for _ in 0..<steps {
            while !frontier.isEmpty {
                let next = frontier.removeFirst()
                [Direction.up.takeStep(next, maxX: grid.count - 1, maxY: grid[0].count - 1),
                Direction.down.takeStep(next, maxX: grid.count - 1, maxY: grid[0].count - 1),
                Direction.left.takeStep(next, maxX: grid.count - 1, maxY: grid[0].count - 1),
                 Direction.right.takeStep(next, maxX: grid.count - 1, maxY: grid[0].count - 1)].forEach {
                    if let neighbour = $0 , grid[neighbour.x][neighbour.y] != "#" {
                        nextFrontier.insert(neighbour)
                    }
                }
            }
            frontier = nextFrontier
            nextFrontier = Set<Coordinate>()
        }
        return frontier.count
    }
    
    func part1Solution(input: [String]) -> String {
        let ((startX, startY), grid) = parseInput(input: input)
        let steps = grid.count < 20 ? 6 : 64
        var answer = explore(grid: grid, startX: startX, startY: startY, steps: steps)
        return "\(answer)"
    }
    
    private func exploreUnbounded(grid: [[Character]], startX: Int, startY: Int, steps: Int) -> Int {
        var frontier = [StackedCoordinate(coordinate: Coordinate(x: startX, y: startX))]
        var nextFrontierMap = [Coordinate: StackedCoordinate]()
        for iteration in 0..<steps {
            while !frontier.isEmpty {
                let next = frontier.removeFirst()
                [takeWrappedStep(coordinate: next, direction: .up, maxX: grid.count, maxY: grid[0].count),
                 takeWrappedStep(coordinate: next, direction: .down, maxX: grid.count, maxY: grid[0].count),
                 takeWrappedStep(coordinate: next, direction: .left, maxX: grid.count, maxY: grid[0].count),
                 takeWrappedStep(coordinate: next, direction: .right, maxX: grid.count, maxY: grid[0].count)
                ].forEach { neighbour in
                    if grid[neighbour.coordinate.x][neighbour.coordinate.y] != "#" {
                        if let stacked = nextFrontierMap[neighbour.coordinate] {
                            nextFrontierMap[neighbour.coordinate] = combine(stacked, neighbour)
                        } else {
                            nextFrontierMap[neighbour.coordinate] = neighbour
                        }
                    }
                }
            }
            frontier = nextFrontierMap.values.map { $0 }
            nextFrontierMap.removeAll()
        }
        return frontier.map { $0.wraps.count }.reduce(0, +)
    }
    
    private func exploreQuadratic(grid: [[Character]], startX: Int, startY: Int, target: Int) -> Int {
        var frontier = Set<Coordinate>(arrayLiteral: Coordinate(x:startX, y:startY))
        var nextFrontier = Set<Coordinate>()
        
        var cellsVisited = 0
        var visited = Set<Coordinate>()
        var iteration = 0
        
        /// Checkpoints
        var nodesVisited = [Int]()
        var nodesVisitedFirstDerivarite = [Int]()
        var nodesVisitedSecondDerivative = [Int]()
        
        while iteration < 1000 {
            iteration += 1
            while !frontier.isEmpty {
                let next = frontier.removeFirst()
                [Direction.up.takeStep(next),
                Direction.down.takeStep(next),
                Direction.left.takeStep(next),
                 Direction.right.takeStep(next)].forEach {
                    if let neighbour = $0, !visited.contains(neighbour), grid[mod(neighbour.x, grid.count)][mod(neighbour.y, grid.count)] != "#" {
                        nextFrontier.insert(neighbour)
                        visited.insert(neighbour)
                    }
                }
            }
            if iteration % 2 == 1 {
                cellsVisited += nextFrontier.count
                if (iteration % (grid.count * 2) == (grid.count / 2)) {
                    nodesVisited.append(cellsVisited);
                    let currTotals = nodesVisited.count;
                    if currTotals > 1 {
                        nodesVisitedFirstDerivarite.append(nodesVisited.last! - nodesVisited[currTotals - 2])
                    }
                    let currDeltas = nodesVisitedFirstDerivarite.count
                    if currDeltas > 1 {
                        nodesVisitedSecondDerivative.append(nodesVisitedFirstDerivarite.last! - nodesVisitedFirstDerivarite[currDeltas - 2]);
                    }
                    if(nodesVisitedSecondDerivative.count > 0){
                        break;
                    }
                }
            }
            frontier = nextFrontier
            nextFrontier = Set<Coordinate>()
        }
        
        let requiredCycleCount = (target / (grid.count * 2)) - 1
        let currentCycle = (iteration / (grid.count * 2)) - 1
        let cyclesLeft = requiredCycleCount - currentCycle
        let cyclesLeftIntegral = (requiredCycleCount * (requiredCycleCount + 1))/2 - (currentCycle * (currentCycle + 1))/2
        let secondDerivative = nodesVisitedSecondDerivative.last!
        let firstDelta = nodesVisitedFirstDerivarite.first!
        return ((secondDerivative * cyclesLeftIntegral) + (firstDelta * cyclesLeft) + cellsVisited)
    }
    
    func part2Solution(input: [String]) -> String {
        let ((startX, startY), grid) = parseInput(input: input)
        let steps = grid.count < 20 ? 1000 : 26501365
        var answer = exploreQuadratic(grid: grid, startX: startX, startY: startY, target: steps)
        return "\(answer)"
    }
    
    private func takeWrappedStep(coordinate: StackedCoordinate, direction: Direction, maxX: Int, maxY: Int) -> StackedCoordinate {
        let newCoords = direction.takeStep(coordinate.coordinate)!
        let wrappedCoords = Coordinate(x: mod(newCoords.x, maxX), y: mod(newCoords.y, maxY))
        let xShift = newCoords.x < 0 ? -1 : newCoords.x >= maxX ? 1 : 0
        let yShift = newCoords.y < 0 ? -1 : newCoords.y >= maxX ? 1 : 0
        let newWraps = Set(coordinate.wraps.map { Wrap($0.x + xShift, $0.y + yShift) })
        return StackedCoordinate(coordinate: wrappedCoords, wraps: newWraps)
    }
    
    private func combine(_ a: StackedCoordinate, _ b: StackedCoordinate) -> StackedCoordinate {
        var newWraps = a.wraps
        b.wraps.forEach { newWraps.insert($0)}
        return StackedCoordinate(coordinate: a.coordinate, wraps: newWraps)
    }
    
    struct StackedCoordinate {
        let coordinate: Coordinate
        let wraps: Set<Wrap>
        
        init(coordinate: Coordinate, wraps: Set<Wrap>) {
            self.coordinate = coordinate
            self.wraps = wraps
        }
        
        init(coordinate: Coordinate) {
            self.coordinate = coordinate
            self.wraps = Set(arrayLiteral: Wrap(0, 0))
        }
    }
}

struct Wrap: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

//TODO move to utils
func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}

/// 381938769 too low
