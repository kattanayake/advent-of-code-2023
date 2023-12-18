//
//  Utils.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 11/30/23.
//

import Foundation

/// Extensions for indexing into Strings
/// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift/38215613#38215613
extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

enum Direction {
    case up, down, left, right
    
    func takeStep(_ coord: Coordinate, maxX: Int? = nil, maxY: Int? = nil) -> Coordinate? {
        let next: Coordinate
        switch(self){
        case .up: next = Coordinate(x:coord.x - 1, y:coord.y)
        case .down: next = Coordinate(x:coord.x + 1, y:coord.y)
        case .left: next = Coordinate(x:coord.x , y:coord.y - 1)
        case .right: next = Coordinate(x:coord.x , y:coord.y + 1)
        }
        
        guard let maxX, let maxY else {
            return next
        }
        
        if next.x <= maxX, next.y <= maxY, next.x >= 0, next.y >= 0 {
            return next
        }
        return nil
    }
    
    func turnLeft(_ coord: Coordinate, maxX: Int? = nil, maxY: Int? = nil) -> (Coordinate, Direction)? {
        let next: (Coordinate?, Direction)
        switch(self){
        case .up: next = (Direction.left.takeStep(coord, maxX: maxX, maxY: maxY), .left)
        case .down: next = (Direction.right.takeStep(coord, maxX: maxX, maxY: maxY), .right)
        case .left: next = (Direction.down.takeStep(coord, maxX: maxX, maxY: maxY), .down)
        case .right: next = (Direction.up.takeStep(coord, maxX: maxX, maxY: maxY), .up)
        }
        if let nextCoord = next.0 {
            return (nextCoord, next.1)
        }
        return nil
    }
    
    func turnRight(_ coord: Coordinate, maxX: Int? = nil, maxY: Int? = nil) -> (Coordinate, Direction)? {
        let next: (Coordinate?, Direction)
        switch(self){
        case .down: next = (Direction.left.takeStep(coord, maxX: maxX, maxY: maxY), .left)
        case .up: next = (Direction.right.takeStep(coord, maxX: maxX, maxY: maxY), .right)
        case .right: next = (Direction.down.takeStep(coord, maxX: maxX, maxY: maxY), .down)
        case .left: next = (Direction.up.takeStep(coord, maxX: maxX, maxY: maxY), .up)
        }
        if let nextCoord = next.0 {
            return (nextCoord, next.1)
        }
        return nil
    }
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    
    init(_ coords: (Int, Int)) {
        self.x = coords.0
        self.y = coords.1
    }
    
    init (x: Int, y: Int){
        self.x = x
        self.y = y
    }
}


