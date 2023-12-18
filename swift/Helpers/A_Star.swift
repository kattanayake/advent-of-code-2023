//
//  A_Star.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/17/23.
//

import Foundation

/// Copied from https://github.com/Mistborn94/advent-of-code-2023/blob/master/src/main/kotlin/helper/graph/AStarSearch.kt
func A_Star<K: Equatable & Hashable>(
    start: K,
    isEnd: (K) -> Bool,
    neighbours: (K) -> [K],
    cost: (K, K) -> Int,
    heuristic: ((K) -> Int) = { _ in 0 }
) -> GraphSearchResult<K> {
    var openSet = Heap<ScoredVertex<K>>(comparator: { lhs, rhs in (lhs.score + lhs.heuristic) < (rhs.score + rhs.heuristic) })
    openSet.add(ScoredVertex(vertex: start, score: 0, heuristic: heuristic(start)))
    var endVertex: K? = nil
    var seenPoints: [K: SeenVertex<K>] =  [start : SeenVertex(cost:0, prev:nil)]
    
    while endVertex == nil {
        if (openSet.isEmpty()) {
           return GraphSearchResult(start: start, end: nil,result: seenPoints)
        }

        let nextScoredVertex = openSet.poll()
        let nextVertex = nextScoredVertex.vertex
        let nextScore = nextScoredVertex.score
        if isEnd(nextVertex) {
            endVertex = nextVertex
        }

        let nextPoints = neighbours(nextVertex)
            .filter { seenPoints[$0] == nil }
            .map { next in ScoredVertex(vertex: next, score: nextScore + cost(nextVertex, next), heuristic: heuristic(next)) }

        openSet.addAll(nextPoints)
        nextPoints.forEach {
            seenPoints[$0.vertex] = SeenVertex(cost: $0.score, prev: nextVertex)
        }
   }

    return GraphSearchResult(start: start, end: endVertex, result: seenPoints)
}

struct ScoredVertex<K: Equatable>: Comparable{
    let vertex: K
    let score: Int
    let heuristic: Int
    
    static func < (lhs: ScoredVertex, rhs: ScoredVertex) -> Bool {
        (lhs.score + lhs.heuristic) < (rhs.score + rhs.heuristic)
    }
}

struct GraphSearchResult<K: Hashable> {
    let start: K
    let end: K?
    private let result: [K: SeenVertex<K>]
    
    init(start: K, end: K?, result: [K : SeenVertex<K>]) {
        self.start = start
        self.end = end
        self.result = result
    }
    
    func getScore(_ vertex: K) -> Int? { result[vertex]?.cost }
    
    func getScore() -> Int? {
        guard let end else {
            return nil
        }
        return getScore(end)
    }
    
    func getPath() -> [K] {
        guard let end else {
            return [K]()
        }
        return getPath(end, pathEnd: [K]())
    }

    func seen() -> Set<K> { Set(result.keys) }
    
    private func getPath(_ endVertex: K,  pathEnd: [K]) -> [K]{
        let previous = result[endVertex]?.prev
        guard let previous else {
            return [endVertex] + pathEnd
        }
        return getPath(previous, pathEnd: [endVertex] + pathEnd)
    }
}

struct SeenVertex<K>{
    let cost: Int
    let prev: K?
}
