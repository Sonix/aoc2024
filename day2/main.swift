//
//  main.swift
//  day2
//
//  Created by Johannes Loepelmann on 04.12.24.
//

import Foundation

let lines = linesFromFile("day2/day2.input")

let rules = lines.map{$0.split(separator: " ")}.map{$0.map{Int($0)!}}

let validRules = rules.filter{isValid($0)}
print("Valid count: \(validRules.count)")

let invalidRules = rules.filter{!isValid($0)}
let validDampenedRules = invalidRules.filter{isValidDampened($0)}

print("Total valid count: \(validRules.count + validDampenedRules.count)")

func isValidDampened(_ rule: [Int]) -> Bool {
    for i in 0..<rule.count {
        var dampenedRule: [Int]
        
        if i == 0 {
            dampenedRule = Array(rule[1...])
        } else if i == rule.count - 1 {
            dampenedRule = Array(rule[0..<rule.count-1])
        } else {
            dampenedRule = Array([rule[0..<i], rule[i+1..<rule.count]].joined())
        }
        
        if(isValid(dampenedRule)) {
            return true
        }
    }
    
    return false
}

func isValid(_ rule: [Int]) -> Bool {
    let delta = rule[1] - rule[0]
    let direction = delta < 0 ? -1 : 1
    for i in 1..<rule.count {
        let localDelta = rule[i] - rule[i-1]
        let localDirection = localDelta < 0 ? -1 : 1
        if localDirection != direction {
            return false
        }
        if(abs(localDelta) < 1 || abs(localDelta) > 3) {
            return false
        }
    }
    return true
}
