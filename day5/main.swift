//
//  main.swift
//  day5
//
//  Created by Johannes Loepelmann on 06.12.24.
//

import Foundation

let lines = linesFromFile("day5/day5.input")
let rules = lines.map { $0.split(separator: "|").map {Int($0)}}.filter{$0.count > 1}
let updates = lines.map { $0.split(separator: ",").map {Int($0)}}.filter{$0.count > 1}

let validUpdates = updates.filter { update in rules.allSatisfy { rule in ruleValid(rule, update) }}
let invalidUpdates = updates.filter { update in !rules.allSatisfy { rule in ruleValid(rule, update) }}
let validatedUpdates = invalidUpdates.map { makeValid($0) }

print("Valid Updates: \(validUpdates.count)")
print("Result: \(validUpdates.map{middleOf($0)!}.reduce(0, +))")

print("Invalid Updates: \(validatedUpdates.count)")
print("Result: \(validatedUpdates.map{middleOf($0)!}.reduce(0, +))")


func ruleValid(_ rule: [Int?], _ update: [Int?]) -> Bool {
    if !rule.allSatisfy({ update.contains($0) }) {
        return true
    }
    
    if update.firstIndex(of: rule[0])! > update.firstIndex(of: rule[1])! {
        return false
    }
    
    return true
}

func middleOf(_ array: [Int?]) -> Int? {
    guard array.count > 1 else { return nil }
    return array[array.index(array.startIndex, offsetBy: array.count / 2)]
}

func makeValid(_ update: [Int?]) -> [Int?] {
    update.sorted(by: {left, right in rules.filter { $0[0] == left && $0[1] == right }.isEmpty })
}
