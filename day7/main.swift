//
//  main.swift
//  day7
//
//  Created by Johannes Loepelmann on 07.12.24.
//

import Foundation

enum Operator {
    case add
    case mul
    case concat
}

extension Array where Element == Operator {
    func incremented() -> [Operator] {
        var result = self
        var carry = false
        for i in (0..<count).reversed() {
            carry = false
            switch self[i] {
            case .add: result[i] = .mul
            case .mul: result[i] = .concat
            case .concat:
                result[i] = .add
                carry = true
            }
            if !carry { break }
        }
        
        return result
    }
}

struct Equation {
    let testValue: Int
    let numbers: [Int]
    
    init(fromLine line: Substring) {
        self.testValue = line.split(separator: ":").map { Int($0) }[0]!
        self.numbers = line.split(separator: ":")[1].split(separator: " ").compactMap { Int($0) }
    }
    
    func possible() -> Bool {
        var operators: [Bool] = Array(repeating: false, count: numbers.count - 1)
        
        while true {
            var acc = numbers[0]
            for i in 0..<operators.count {
                switch operators[i] {
                case false: acc += numbers[i + 1]
                case true: acc *= numbers[i + 1]
                }
            }
            
            if acc == testValue { return true }
            if operators.allSatisfy({ $0 == true }) { return false }
            let lastIndex = operators.lastIndex(of: false)!
            operators[operators.lastIndex(of: false)!] = true
            for idx in lastIndex + 1..<operators.count { operators[idx] = false }
        }
    }
    
    func possibleV2() -> Bool {
        var operators: [Operator] = Array(repeating: .add, count: numbers.count - 1)
        
        while true {
            var acc = numbers[0]
            for i in 0..<operators.count {
                switch operators[i] {
                case .add: acc += numbers[i + 1]
                case .mul: acc *= numbers[i + 1]
                case .concat:
                    acc = Int(acc.description + numbers[i + 1].description)!
                }
            }
            
            if acc == testValue { return true }
            operators = operators.incremented()
            if operators.allSatisfy( { $0 == .add }) { return false }
        }
    }
}

let lines = linesFromFile("day7/day7.input")
let equations = lines.map(Equation.init)

let possibleEquations = equations.filter { $0.possible() }

let impossibleEquations = equations.filter { !$0.possible() }
let possibleWithConcat = impossibleEquations.filter { $0.possibleV2() }

print("Result1: \(possibleEquations.reduce(0, { $0 + $1.testValue }))")
print("Result2: \([possibleEquations, possibleWithConcat].joined().reduce(0, { $0 + $1.testValue }))")
