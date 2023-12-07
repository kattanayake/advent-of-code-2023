//
//  Day07.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/5/23.
//

import Foundation

struct Day07: Day {
    func part1Solution(input: [String]) -> String {
        var wagers = [(Hand, Int)]()
        input.forEach { round in
            let roundParts = round.split(separator: " ")
            wagers.append((Hand(cards: String(roundParts[0])), Int(roundParts[1])!))
        }
        wagers.sort {
            let (hand0, _) = $0
            let (hand1, _) = $1
            return hand0 < hand1
        }
        var answer = 0
        for (idx, element) in wagers.enumerated(){
            let (_, wage) = element
            answer += ((idx + 1) * wage)
        }
        return "\(answer)"
    }
    
    func part2Solution(input: [String]) -> String {
        var wagers = [(Hand, Int)]()
        input.forEach { round in
            let roundParts = round.split(separator: " ")
            wagers.append((Hand(cards: String(roundParts[0]), isPartTwo: true), Int(roundParts[1])!))
        }
        wagers.sort {
            let (hand0, _) = $0
            let (hand1, _) = $1
            return hand0 < hand1
        }
        var answer = 0
        for (idx, element) in wagers.enumerated(){
            let (_, wage) = element
            answer += ((idx + 1) * wage)
        }
        return "\(answer)"
    }
    
    
}

struct Hand: Hashable, Comparable {
    static func < (lhs: Hand, rhs: Hand) -> Bool {
        // Comparing by type first
        if(lhs.type != rhs.type){
            return lhs.type < rhs.type
        }
        
        // If of the same type, compare card by card
        for index in 0..<lhs.cards.count {
            if(lhs.cards[index] != rhs.cards[index]) {
                return lhs.cards[index] < rhs.cards[index]
            }
        }
        // If exactly identical, return falce
        return false
    }
    
    let cards: [CamelCard]
    let type: HandType
    
    init(cards: String) {
        self.cards = cards.map { CamelCard.fromChar($0) }
        var cardCounts = [Character:Int]()
        cards.forEach {
            cardCounts[$0] = cardCounts[$0, default: 0] + 1
        }
        let maxDuplicates = cardCounts.values.max()
        switch(maxDuplicates){
        case 5:
            type = HandType.five_of_a_kind
        case 4:
            type = HandType.four_of_a_kind
        case 3:
            if cardCounts.keys.count == 2 { type = HandType.full_house } else { type = HandType.three_of_a_kind }
        case 2:
            if cardCounts.keys.count == 3 { type = HandType.two_pair } else { type = HandType.one_pair }
        default:
            type = HandType.high_card
        }
    }
    
    init(cards: String, isPartTwo: Bool) {
        self.cards = cards.map { CamelCard.fromChar($0, isPartTwo: true) }
        var cardInts = [Character:Int]()
        var jokerCount = 0
        cards.forEach {
            if $0 == "J" {
                jokerCount += 1
            } else {
                cardInts[$0] = cardInts[$0, default: 0] + 1
            }
        }
        let maxDuplicates = cardInts.values.max()
        switch(maxDuplicates){
        case 5:
            type = HandType.five_of_a_kind
        case 4:
            if jokerCount == 1 {
                type = HandType.five_of_a_kind
            } else {
                type = HandType.four_of_a_kind
            }
        case 3:
            if (jokerCount == 2) {
                type = HandType.five_of_a_kind
            } else if (jokerCount == 1) {
                type = HandType.four_of_a_kind
            } else if cardInts.keys.count == 2 {
                type = HandType.full_house
            } else {
                type = HandType.three_of_a_kind
            }
        case 2:
            if jokerCount == 3 {
                type = HandType.five_of_a_kind
            } else if jokerCount == 2 {
                type = HandType.four_of_a_kind
            } else if jokerCount == 1 {
                if cardInts.keys.count == 2 {
                    type = HandType.full_house
                } else {
                    type = HandType.three_of_a_kind
                }
            } else if cardInts.keys.count == 3 {
                type = HandType.two_pair
            } else {
                type = HandType.one_pair
            }
        case 1:
            if jokerCount == 4 {
                type = HandType.five_of_a_kind
            } else if jokerCount == 3 {
                type = HandType.four_of_a_kind
            } else if jokerCount == 2 {
                type = HandType.three_of_a_kind
            } else if jokerCount == 1 {
                type = HandType.one_pair
            } else {
                type = HandType.high_card
            }
        default: // All joker case
            type = HandType.five_of_a_kind
        }
    }
    
}

enum HandType: Int, Comparable {
    static func < (lhs: HandType, rhs: HandType) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
    
    case five_of_a_kind
    case four_of_a_kind
    case full_house
    case three_of_a_kind
    case two_pair
    case one_pair
    case high_card
}

enum CamelCard: Int, Comparable {
    static func < (lhs: CamelCard, rhs: CamelCard) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
    
    case A, K, Q, J, T, NINE, EIGHT, SEVEN, SIX, FIVE, FOUR, THREE, TWO, JOKER
    
    static func fromChar(_ from: Character, isPartTwo:Bool = false) -> CamelCard {
        switch(from){
        case "A":
            return CamelCard.A
        case "K":
            return CamelCard.K
        case "Q":
            return CamelCard.Q
        case "J":
            if isPartTwo { return CamelCard.JOKER } else { return CamelCard.J }
        case "T":
            return CamelCard.T
        case "9":
            return CamelCard.NINE
        case "8":
            return CamelCard.EIGHT
        case "7":
            return CamelCard.SEVEN
        case "6":
            return CamelCard.SIX
        case "5":
            return CamelCard.FIVE
        case "4":
            return CamelCard.FOUR
        case "3":
            return CamelCard.THREE
        default:
            return CamelCard.TWO
        }
    }
}
