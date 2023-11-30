//
//  Day.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 11/29/23.
//

import Foundation

protocol Day {
    /// Solves part 1 of the problem
    func part1Solution(input: [String]) -> String
    
    /// Solves part 2 of the problem
    func part2Solution(input: [String]) -> String
}

extension Day {
    
    /// Validates that the implemented [part1Solution] correctly solves the example input to the problem
    func validate() {
        let expectedOutput = readFile(from: File.exampleOut)[0]
        let actualOutput = part1Solution(input: readFile(from: File.exampleIn))
        assert(expectedOutput == actualOutput)
    }
    
    func part1() {
        print(part1Solution(input: readFile(from: File.part1)))
    }
    
    func part2() {
        print(part2Solution(input: readFile(from: File.part2)))
    }
}

// MARK: File IO extensions
extension Day {
    private var baseResourcePath: String {
        get {
            return #file
                .replacing(#"/Solutions/"#, with: "/Resources/")
                .replacing("Day.swift", with: name)
        }
    }
    
    private var name: String {
        get { return String(String(describing: self).split(separator: "(")[0]) }
    }
    
    private func readFile(from:File) -> [String] {
        do {
            return try String(contentsOfFile: baseResourcePath + from.path).split(separator: "\n").map { String($0) }
        } catch {
            print(error.localizedDescription)
            exit(1)
        }
    }
}

private enum File {
    case exampleIn
    case exampleOut
    case part1
    case part2
    
    var path: String {
        switch(self){
        case .exampleIn:
            return "/ExampleIn.txt"
        case .exampleOut:
            return "/ExampleOut.txt"
        case .part1:
            return "/Part1In.txt"
        case .part2:
            return "/Part2In.txt"
        }
    }
}
