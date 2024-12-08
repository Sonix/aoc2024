//
//  main.swift
//  day8
//
//  Created by Johannes Loepelmann on 08.12.24.
//

import Foundation

let map = linesFromFile("day8/day8.input").map { Array($0) }
let antennaTypes = Set(map.joined().filter { $0 != "." })

var antinodes = Array(repeating: Array(repeating: false, count: map[0].count), count: map.count)

for antennaType in antennaTypes {
    let positions = map.findPositions(of: antennaType)
    let combinations = positions.combinations(of: 2)
    
    for combination in combinations {
        let distance = distance(combination[0], combination[1])
        let point1 = add(combination[0], inverse(distance))
        let point2 = add(combination[1], distance)
                
        _ = antinodes.safeSet(point1)
        _ = antinodes.safeSet(point2)
    }
}

antinodes.print()
print("Result 1: \(antinodes.joined().count(where: { $0 == true}))")

for antennaType in antennaTypes {
    let positions = map.findPositions(of: antennaType)
    let combinations = positions.combinations(of: 2)
    
    for combination in combinations {
        _ = antinodes.safeSet(combination[0])
        _ = antinodes.safeSet(combination[1])
        
        let distance = distance(combination[0], combination[1])
        
        var current = combination[0]
        while antinodes.safeSet(current) {
            current = add(current, inverse(distance))
        }
        current = combination[1]
        while antinodes.safeSet(current) {
            current = add(current, distance)
        }
    }
}

antinodes.print()
print("Result 2: \(antinodes.joined().count(where: { $0 == true}))")

func add(_ a: (Int, Int), _ b: (Int, Int)) -> (Int, Int) {
    let x = a.0 + b.0
    let y = a.1 + b.1
    return (x, y)
}

func inverse(_ a: (Int, Int)) -> (Int, Int) {
    let x = -a.0
    let y = -a.1
    return (x, y)
}

extension Array where Element == [Bool] {
    mutating func safeSet(_ pos: (Int, Int)) -> Bool {
        self.safeSet(pos.0, pos.1)
    }
    
    mutating func safeSet(_ x: Int, _ y: Int) -> Bool {
        guard x >= 0 && y >= 0 else { return false}
        guard x < self[0].count else { return false}
        guard y < count else { return false}
        self[y][x] = true
        return true
    }
    
    func print() {
        for row in self {
            Swift.print(row.map { $0 ? "#" : "."}.joined())
        }
    }
}

extension Array where Element == [Character] {
    func findPositions(of type: Character) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        for y in 0..<count {
            for x in 0..<self[y].count {
                if self[y][x] == type {
                    result.append((x, y))
                }
            }
        }
        
        return result
    }
}

extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
    
    func combinations(of size: Int) -> [[Element]] {
        self.combinationsWithoutRepetition.filter { $0.count == size }
    }
}

func distance(_ first: (Int, Int),_ second: (Int, Int)) -> (Int, Int) {
    let distX = second.0 - first.0
    let distY = second.1 - first.1
    return (distX, distY)
}
