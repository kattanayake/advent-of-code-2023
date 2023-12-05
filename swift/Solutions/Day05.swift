//
//  Day05.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/3/23.
//

import Foundation

struct Day05: Day {
    func part1Solution(input: [String]) -> String {
        var data = input[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        var rubrick = [Range<Int>:Range<Int>]()
        
        func doDataUpdate(){
            data = data.sorted()
            let sortedRubrick = rubrick.keys.sorted(by: {first, second in first.lowerBound < second.lowerBound})
            var seedIndex = 0
            var rubrickIndex = 0
            while(seedIndex < data.count && rubrickIndex < sortedRubrick.count){
                let curRubrick = sortedRubrick[rubrickIndex]
                let curRubrickMapping = rubrick[curRubrick]!
                let curSeedData = data[seedIndex]
                if(curSeedData > curRubrick.upperBound){
                    rubrickIndex += 1
                } else {
                    // This seed falls within this range
                    if(curSeedData >= curRubrick.lowerBound && curSeedData <= curRubrick.upperBound){
                        data[seedIndex] = curRubrickMapping.lowerBound + (curSeedData - curRubrick.lowerBound)
                    }
                    seedIndex += 1
                }
            }
        }
        
        input[2...].forEach { line in
            if(line.contains("map:")){ // Done parsing rubrick, can map data
                doDataUpdate()
                rubrick.removeAll()
            } else {
                let rubrickParts = line.split(separator: " ")
                let destStart = Int(rubrickParts[0])!
                let sourceStart = Int(rubrickParts[1])!
                let rangeLength = Int(rubrickParts[2])!
                rubrick[sourceStart..<(sourceStart+rangeLength)] = destStart..<(destStart+rangeLength)
            }
        }
        doDataUpdate()
        return "\(data.min()!)"
    }
    
    func part2Solution(input: [String]) -> String {
        let dataParts = input[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        var data = (0..<(dataParts.count/2)).map {
            let startIndex = $0 * 2
            let endIndex = startIndex + 1
            return dataParts[startIndex]..<(dataParts[startIndex]+dataParts[endIndex])
        }
        var rubrick = [Range<Int>:Range<Int>]()
        
        func doDataUpdate(){
            data = data.sorted(by: {first, second in first.lowerBound < second.lowerBound})
            let sortedRubrick = rubrick.keys.sorted(by: {first, second in first.lowerBound < second.lowerBound})
            var seedIndex = 0
            var rubrickIndex = 0
            while(seedIndex < data.count && rubrickIndex < sortedRubrick.count){
                let curRubrick = sortedRubrick[rubrickIndex]
                let curRubrickMapping = rubrick[curRubrick]!
                let curSeedData = data[seedIndex]
                if(curSeedData.lowerBound > (curRubrick.upperBound-1)){ // no overlap AND rubrick < seed range
                    rubrickIndex += 1
                } else { // Rubrik not completely smaller than seed range
                    
                    if(curSeedData.lowerBound >= curRubrick.lowerBound  && curSeedData.upperBound < curRubrick.upperBound){
                        // Full overlap scenario
                        let newMappingStart = curRubrickMapping.lowerBound + (curSeedData.lowerBound - curRubrick.lowerBound)
                        let newMappingEnd = newMappingStart + curSeedData.count
                        data[seedIndex] = newMappingStart..<newMappingEnd
                        
                    } else if (curSeedData.lowerBound >= curRubrick.lowerBound && curSeedData.lowerBound < curRubrick.upperBound){
                        // Left overlap
                        let newMappingStart = curRubrickMapping.lowerBound + (curSeedData.lowerBound - curRubrick.lowerBound)
                        let newMappingEnd = curRubrickMapping.upperBound
                        data[seedIndex] = newMappingStart..<newMappingEnd
                        
                        let leftoverStart = curRubrick.upperBound
                        let leftoverEnd = curSeedData.upperBound
                        data.insert(leftoverStart..<leftoverEnd, at: seedIndex+1)
                        
                    } else if (curSeedData.upperBound < curRubrick.upperBound && curSeedData.upperBound > curRubrick.lowerBound) {
                        let newMappingStart = curRubrickMapping.lowerBound
                        let newMappingEnd = newMappingStart + (curSeedData.upperBound - curRubrick.lowerBound)
                        data[seedIndex] = newMappingStart..<newMappingEnd
                        
                        let leftoverStart = curSeedData.lowerBound
                        let leftoverEnd = curRubrick.lowerBound
                        data.insert(leftoverStart..<leftoverEnd, at: seedIndex)
                        seedIndex += 1
                    }
                    // Partial overlap on left
                    // Partial overlap on right
                    // This seed falls within this range
                    seedIndex += 1
                }
            }
        }
        
        input[2...].forEach { line in
            if(line.contains("map:")){ // Done parsing rubrick, can map data
                doDataUpdate()
                rubrick.removeAll()
            } else {
                let rubrickParts = line.split(separator: " ")
                let destStart = Int(rubrickParts[0])!
                let sourceStart = Int(rubrickParts[1])!
                let rangeLength = Int(rubrickParts[2])!
                rubrick[sourceStart..<(sourceStart+rangeLength)] = destStart..<(destStart+rangeLength)
            }
        }
        doDataUpdate()
        return "\(data.sorted(by: {first, second in first.lowerBound < second.lowerBound})[0].lowerBound)"
    }
    
    
}

///
///25834266
///97676188
///486613012
///
///
