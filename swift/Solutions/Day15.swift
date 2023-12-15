//
//  Day15.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/14/23.
//

import Foundation

struct Day15: Day {
    
    private func hash(_ label: String.SubSequence) -> Int {
        var ans = 0
        for char in label {
            ans += Int(char.asciiValue!)
            ans *= 17
            ans %= 256
        }
        return ans
    }
    
    func part1Solution(input: [String]) -> String {
        var answer = 0
        input[0].split(separator: ",").forEach { line in
            answer += hash(line)
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var boxes = [Box]()
        for _ in 0..<256{
            boxes.append(Box())
        }
        let instructions = input[0].split(separator: ",")
        for instruction in instructions {
            if instruction.last == "-" {
                let label = instruction[0..<instruction.count-1]
                let boxNum = hash(label)
                boxes[boxNum].remove(String(label))
            } else {
                let label = instruction.split(separator: "=")[0]
                let focal = Int(String(instruction.split(separator: "=")[1]))!
                let boxNum = hash(label)
                boxes[boxNum].add(String(label), focal)
            }
        }
        var answer = 0
        for (idx, box) in boxes.enumerated(){
            answer += box.focusingPower(idx)
        }
        
        return "\(answer)"
    }
    
    
}

class Box {
    var lenses = [String: Int]()
    var lensOrder = [(String, Int)]()
    
    func remove(_ lens: String){
        if let index = lenses[lens] {
            lensOrder.remove(at: index)
            for newIndex in index..<lensOrder.count {
                lenses[lensOrder[newIndex].0] = newIndex
            }
            lenses.removeValue(forKey: lens)
        }
    }
    
    func add(_ lens: String, _ focal: Int){
        if let idx = lenses[lens]{
            lensOrder[idx] = (lens, focal)
        } else {
            lensOrder.append((lens, focal))
            lenses[lens] = lensOrder.count-1
        }
    }
    
    func focusingPower(_ boxNum: Int) -> Int {
        var value = 0
        for (idx, (_, power)) in lensOrder.enumerated() {
           value += ((1 + boxNum) * (1+idx) * power)
        }
        return value
    }
}
