//
//  Day20.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/19/23.
//

import Foundation

struct Day20: Day {
    
    func parseInput(input: [String]) -> [String: Module] {
        var modules = [String: Module]()
        input.filter { !$0.isEmpty }.forEach { line in
            let lineParts = line.split(separator: " ->")
            let mod = lineParts[0].trimmingCharacters(in: .whitespaces)
            let destinations = lineParts[1].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            switch(mod[0]){
            case "%": modules[String(mod[1...])] = .flipflop(connections: Module.Connections(outputs: destinations), state: false)
            case "&": modules[String(mod[1...])] = .conjunction(connections: Module.Connections(outputs: destinations), connectionHistory: [String:Pulse]())
            default : modules[String(mod)] = .broadcast(connections: Module.Connections(outputs: destinations))
            }
        }
        
        modules.forEach { (name, module) in
            let destinations: [String]
            switch(module){
            case .flipflop(connections: let connections, state: _): destinations = connections.outputs
            case .conjunction(connections: let connections, connectionHistory: _): destinations = connections.outputs
            case .broadcast(connections: let connections): destinations = connections.outputs
            }
            for dest in destinations {
                switch(modules[dest]){
                case .conjunction(connections: let connections, connectionHistory: var history):
                    history[name] = .low
                    modules[dest] = .conjunction(connections: connections, connectionHistory: history)
                default:continue
                }
            }
        }
        
        return modules
    }
    
    func simulate(modules: inout [String: Module], waitingForRx: Bool = false) -> Int {
        var highPulses = 0
        var lowPulses = 0
        
        let upperlimit = waitingForRx ? Int.max : 1000
        
        var cycleCounts = [String: Int]()
        var cycleLengths = [String: Int]()
        let target: Int
        switch(modules["zg"]){
        case .conjunction(connections: _ , connectionHistory: let history): target = history.count
        default: target = Int.max
        }
        
        func solvePartTwo(_ source: String, _ cycle: Int) -> Int? {
            if let prevCycle = cycleCounts[source] {
                cycleLengths[source] = cycle - prevCycle
            }
            cycleCounts[source] = cycle
            if cycleLengths.count == target {
                var ans = 1
                for cycle in cycleLengths.values {
                    ans = lcm(ans, cycle)
                }
                return ans
            }
            return nil
        }
        
        for iteration in 0..<upperlimit {
            var pulses = [(String, Pulse, String)](arrayLiteral: ("button", .low, "broadcaster"))
            while !pulses.isEmpty {
                let (source, pulse, destination) = pulses.removeFirst()
                
                if pulse == .high {
                    highPulses += 1
                } else {
                    lowPulses += 1
                }
                switch(modules[destination]){
                case .flipflop(connections: let connections, state: var state):
                    if pulse == .low {
                        state = !state
                        let newPulse: Pulse = state ? .high : .low
                        connections.outputs.forEach { pulses.append((destination, newPulse, $0 )) }
                        modules[destination] = .flipflop(connections: connections, state: state)
                    }
                case .conjunction(connections: let connections, connectionHistory: var connectionHistory):
                    connectionHistory[source] = pulse
                    let newPulse: Pulse = connectionHistory.values.allSatisfy { $0 == .high } ? .low : .high
                    connections.outputs.forEach { pulses.append((destination, newPulse, $0)) }
                    modules[destination] = .conjunction(connections: connections, connectionHistory: connectionHistory)
                    if waitingForRx, destination == "zg", pulse == .high, let ans = solvePartTwo(source, iteration + 1) {
                        return ans
                    }
                case .broadcast(connections: let connections):
                    connections.outputs.forEach { pulses.append((destination, pulse, $0))  }
                default: continue
                }
            }
        }
        
        return highPulses * lowPulses
    }
    
    func part1Solution(input: [String]) -> String {
        var modules = parseInput(input: input)
        let answer = simulate(modules: &modules)
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var modules = parseInput(input: input)
        guard let _ = modules["zg"] else {
            return "0"
        }
        let answer = simulate(modules: &modules, waitingForRx: true)
        return "\(answer)"
    }
    enum Module: Hashable {
        struct Connections: Hashable {
            let outputs: [String]
        }
        case flipflop(connections: Connections, state: Bool)
        case conjunction(connections: Connections, connectionHistory: [String:Pulse])
        case broadcast(connections: Connections)
    }
    
    enum Pulse {
        case high, low
    }
}
