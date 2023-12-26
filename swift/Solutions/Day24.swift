//
//  Day24.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/22/23.
//

import Foundation
import LASwift

struct Day24: Day {
    
    private func parseInput(_ input: [String]) -> [Hail] {
        input.filter({!$0.isEmpty}).map { line in
            let lineParts = line.split(separator: "@")
            let positions = lineParts[0].split(separator: ",").map { Double($0.trimmingCharacters(in: .whitespaces))! }
            let velocities = lineParts[1].split(separator: ",").map { Double($0.trimmingCharacters(in: .whitespaces))! }
            return Hail(
                x: Hail.Trajectory(startPos: positions[0], velocity: velocities[0]),
                y: Hail.Trajectory(startPos: positions[1], velocity: velocities[1]),
                z: Hail.Trajectory(startPos: positions[2], velocity: velocities[2])
            )
        }
    }
    
    private func calculateIntersection(a: Hail, b: Hail) -> (Double, Double)? {
        let aGradient = a.gradient2D
        let bGradient = b.gradient2D
        if aGradient == bGradient {
            return nil // Parallel lines
        }
        
        let xIntercept = ((-aGradient * a.x.startPos) + a.y.startPos + (bGradient * b.x.startPos) - b.y.startPos) / (bGradient - aGradient)
        let yIntercept = (aGradient * (xIntercept - a.x.startPos)) + a.y.startPos
        
        if a.x.pointIsInFuture(xIntercept), b.x.pointIsInFuture(xIntercept), a.y.pointIsInFuture(yIntercept), b.y.pointIsInFuture(yIntercept) {
            return (xIntercept, yIntercept)
        }
        
        return nil
    }
    
    private func checkIfCollision (a: Hail, b: Hail, min: Double, max: Double) -> Bool {
        if let (xInt, yInt) = calculateIntersection(a: a, b: b) {
            /// Within the bounds we're looking for
            if xInt > min, xInt < max, yInt > min, yInt < max {
                return true
            }
        }
        return false
    }
    
    func part1Solution(input: [String]) -> String {
        let hailstones = parseInput(input)
        let min: Double = hailstones.count < 10 ? 7.0 : 200000000000000.0
        let max: Double = hailstones.count < 10 ? 27.0 : 400000000000000.0
        var answer = 0
        for i in 0..<hailstones.count {
            for ii in (i+1)..<hailstones.count {
                if checkIfCollision(a: hailstones[i], b: hailstones[ii], min: min, max: max) {
                    answer += 1
                }
            }
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        let hailstones = parseInput(input)
        
        // https://www.reddit.com/r/adventofcode/comments/18pnycy/2023_day_24_solutions/kepu26z/
        // We're trying to find a position vector p_a and a velocity vector v_a such that (p_a + t_i *(v_a)) = (p_i + t_i*(v_i)) for all i hailstones
        // This equation can be rearranged to be (p_a = p_i) = t_i*(v_i - v_a).
        // Because every vector's cross product with itself is 0, we can simplify the above equation by taking the cross prduct of (v_i - v_a)
        // (p_a - p_i) x (v_i - v_a) = t_i*(v_i - v_a) x (v_i - v_a)
        // (p_a - p_i) x (v_i - v_a) = t_i* (0)
        // (p_a - p_i) x (v_i - v_a) = 0
        // Since p_a and v_a are both vectors of 3 dimensions each, and are related to each other, they can be solved for using a system of 6
        // linear equations
        
        // Using the first three hailstones to set up system of equations
        let p0 = Vector(arrayLiteral: hailstones[0].x.startPos, hailstones[0].y.startPos, hailstones[0].z.startPos)
        let p1 = Vector(arrayLiteral: hailstones[1].x.startPos, hailstones[1].y.startPos, hailstones[1].z.startPos)
        let p2 = Vector(arrayLiteral: hailstones[2].x.startPos, hailstones[2].y.startPos, hailstones[2].z.startPos)
        
        let v0 = Vector(arrayLiteral: hailstones[0].x.velocity, hailstones[0].y.velocity, hailstones[0].z.velocity)
        let v1 = Vector(arrayLiteral: hailstones[1].x.velocity, hailstones[1].y.velocity, hailstones[1].z.velocity)
        let v2 = Vector(arrayLiteral: hailstones[2].x.velocity, hailstones[2].y.velocity, hailstones[2].z.velocity)
        
        let b_0 = -crossProduct(p0, v0) + crossProduct(p1, v1)
        let b_1 = -crossProduct(p0, v0) + crossProduct(p2, v2)
        let b = Vector(arrayLiteral: b_0[0], b_0[1], b_0[2],b_1[0], b_1[1], b_1[2])
        
        let topLeft = generateSkewMatrix(for: v0) - generateSkewMatrix(for: v1)
        let topRight = -generateSkewMatrix(for: p0) + generateSkewMatrix(for: p1)
        let bottomLeft = generateSkewMatrix(for: v0) - generateSkewMatrix(for: v2)
        let bottomRight = -generateSkewMatrix(for: p0) + generateSkewMatrix(for: p2)
        
        
        /// A * p_0 | v_0 = b
        /// p_0 | v_0 = A^-1 & b
        let a = (topLeft ||| topRight) === (bottomLeft ||| bottomRight)
        let aInv = inv(a)
        
        let ans = multiply(matrix: aInv, vector: b)
        
        
        let answer = Int(ans[0] + ans[1] + ans[2])
        return "\(answer)"
    }
    
    private func generateSkewMatrix(for vector: Vector) -> Matrix {
        Matrix([
            Vector(arrayLiteral: 0          , -vector[2]  , vector[1]),
            Vector(arrayLiteral: vector[2]   , 0          , -vector[0]),
            Vector(arrayLiteral: -vector[1]  , vector[0]   , 0)
        ])
        
    }
    
    func multiply(matrix: Matrix, vector: Vector) -> Vector {
        var products = [Double](repeating: 0, count: vector.count)
        for i in 0..<matrix.rows {
            for ii in 0..<matrix.cols {
                products[i] += (matrix[row:i][ii] * vector[ii])
            }
        }
        return products
    }
    
    private func crossProduct(_ a: Vector, _ b: Vector) -> Vector {
        multiply(matrix: generateSkewMatrix(for: a), vector: b)
    }
    
    struct Hail {
        let x: Trajectory
        let y: Trajectory
        let z: Trajectory
        
        var gradient2D: Double {
            y.velocity/x.velocity
        }
        
        struct Trajectory {
            let startPos: Double
            let velocity: Double
            
            func pointIsInFuture(_ point: Double) -> Bool {
                let time = (point - startPos)/velocity
                return time > 0
            }
            
        }
    }
    
}
