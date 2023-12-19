//
//  Day19.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/18/23.
//

import Foundation

struct Day19: Day {
    var accepted = [[Param: Int]]()
    
    private func parse(_ input: [String], _ rules: inout [String: WorkFlow]) -> [[Param: Int]] {
        rules.removeAll()
        var isParsingRules  = true
        
        var metals = [[Param: Int]]()
        input.forEach { line in
            if line.isEmpty {
                isParsingRules = false
            } else if isParsingRules {
                let ruleName = String(line.split(separator: "{")[0])
                let parsedRules = line.split(separator: "{")[1].split(separator: "}")[0].split(separator: ",").map { rule in
                    let ruleParts = rule.split(separator: ":")
                    if ruleParts.count == 1 {
                        return Rule(conditionParam: nil, conditionThreshhold: nil, conditionIsLesserThan: nil, destination: String(ruleParts[0]))
                    } else {
                        return Rule(
                            conditionParam: Param.fromChar(ruleParts[0][0]),
                            conditionThreshhold: Int(String(ruleParts[0][2...]))!,
                            conditionIsLesserThan: String(ruleParts[0][1]) == "<",
                            destination: String(ruleParts[1])
                        )
                    }
                }
                rules[ruleName] = WorkFlow(name: ruleName, rules: parsedRules)
            } else {
                var data = [Param: Int]()
                line.trimmingCharacters(in: CharacterSet(charactersIn: "{}")).split(separator: ",").forEach { datum in
                    data[Param.fromChar(datum.split(separator: "=")[0][0])] = Int(String(datum.split(separator: "=")[1]))!
                }
                metals.append(data)
            }
        }
        return metals
    }
    
    private func sort(_ metal: [Param: Int] , _ rules: [String: WorkFlow], _ workflow: WorkFlow, _ accepted: inout [[Param: Int]]){
        
        func resolve(rule: Rule){
            if rule.destination == "A" {
                accepted.append(metal)
            } else if rule.destination != "R" {
                sort(metal, rules, rules[rule.destination]!, &accepted)
            }
            return
        }
        
        for rule in workflow.rules {
            if let condition =  rule.conditionIsLesserThan {
                let conditionMet:Bool
                if condition {
                    conditionMet = metal[rule.conditionParam!]! < rule.conditionThreshhold!
                } else {
                    conditionMet = metal[rule.conditionParam!]! > rule.conditionThreshhold!
                }
                if conditionMet {
                    resolve(rule: rule)
                    return
                }
            } else {
                resolve(rule: rule)
                return
            }
        }
    }
    
    func part1Solution(input: [String]) -> String {
        var rules = [String: WorkFlow]()
        let toSort = parse(input, &rules)
        var accepted = [[Param: Int]]()
        for metal in toSort {
            sort(metal, rules, rules["in"]!, &accepted)
        }
        var answer = 0
        
        for accept in accepted {
            answer += accept.values.reduce(0, +)
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var workflows = [String: WorkFlow]()
        _ = parse(input, &workflows)
        
        var answer = 0
        
        func evaluate(_ workflow: WorkFlow, _ ruleIndex: Int, curRanges: ParamRange){
            let rule = workflow.rules[ruleIndex]
            
            
            func handleTermination(nextParams: ParamRange){
                if rule.destination == "A" {
                    answer += nextParams.containedPoints()
                } else if rule.destination != "R" {
                    evaluate(workflows[rule.destination]!, 0, curRanges: nextParams)
                }
            }
        
            if let lessThan = rule.conditionIsLesserThan {
                let conditionMatchedParams: ParamRange
                let conditionDidNotMatchParams: ParamRange
                if lessThan {
                    /// Condition matches
                    conditionMatchedParams = curRanges.copy(rule.conditionParam!, max: rule.conditionThreshhold! - 1)
                    /// Condition does not match
                    conditionDidNotMatchParams = curRanges.copy(rule.conditionParam!, min: rule.conditionThreshhold!)
                } else {
                    conditionMatchedParams = curRanges.copy(rule.conditionParam!, min: rule.conditionThreshhold! + 1)
                    /// Condition does not match
                    conditionDidNotMatchParams = curRanges.copy(rule.conditionParam!, max: rule.conditionThreshhold!)
                }
                
                assert(!conditionMatchedParams.overlapsWith(other: conditionDidNotMatchParams))
                
                /// Condition did not match, evaluate next rule in this workflow
                evaluate(workflow, ruleIndex + 1, curRanges: conditionDidNotMatchParams)
                /// Condition did match, jump to next workflow
                handleTermination(nextParams: conditionMatchedParams)
            } else {
                handleTermination(nextParams: curRanges)
            }
        }
        
        evaluate(workflows["in"]!, 0, curRanges: ParamRange())
        return "\(answer)"
    }
    
    struct WorkFlow {
        let name: String
        let rules: [Rule]
    }
    
    struct Rule {
        let conditionParam: Param?
        let conditionThreshhold: Int?
        let conditionIsLesserThan: Bool?
        let destination: String
    }
    
    enum Param {
        case x, m, a, s
        
        static func fromChar(_ char: Character)-> Param {
            switch(char){
            case "x": return x
            case "m": return m
            case "a": return a
            default: return s
            }
        }
    }
    
    struct ParamRange {
        var ranges:[Param: ClosedRange<Int>] = [.x:1...4000,.m:1...4000,.a:1...4000,.s:1...4000]
        
        func containedPoints() -> Int {
            (ranges[.x]!.count) * (ranges[.m]!.count) * (ranges[.a]!.count) * (ranges[.s]!.count)
        }
        
        func copy(_ param: Param, min: Int) -> ParamRange {
            if !ranges[param]!.contains(min) {
                print("Something has gone terribly wrong")
            }
            
            /// Because Dictionaries are value types, this mere assignment creates a copy
            var rangesCopy = ranges
            rangesCopy[param]! = min...rangesCopy[param]!.upperBound
            return ParamRange(ranges: rangesCopy)
        }
        
        func copy(_ param: Param, max: Int) -> ParamRange {
            if !ranges[param]!.contains(max) {
                print("Something has gone terribly wrong")
            }
            
            /// Because Dictionaries are value types, this mere assignment creates a copy
            var rangesCopy = ranges
            rangesCopy[param]! = rangesCopy[param]!.lowerBound...max
            return ParamRange(ranges: rangesCopy)
        }
        
        func overlapsWith(other: ParamRange) -> Bool{
            ranges[.x]!.overlaps(other.ranges[.x]!) &&
            ranges[.m]!.overlaps(other.ranges[.m]!) &&
            ranges[.a]!.overlaps(other.ranges[.a]!) &&
            ranges[.s]!.overlaps(other.ranges[.s]!)
        }
    }
}
