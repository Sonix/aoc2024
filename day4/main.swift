//
//  main.swift
//  day4
//
//  Created by Johannes Loepelmann on 06.12.24.
//

import Foundation

print("Hello, World!")

let lines = linesFromFile("day4/day4.input")
let map: [[Character]] = lines.map { Array($0) }

var total = 0
var totalV2 = 0
for y in map.indices {
    for x in map[y].indices {
        total += searchFrom(x, y)
        totalV2 += searchFromV2(x, y)
    }
}

print("Result: \(total)")
print("ResultV2: \(totalV2)")


func charAt(_ x: Int, _ y: Int) -> Character? {
    guard y >= 0 && y < map.count, x >= 0 && x < map[y].count else { return nil }
    return map[y][x]
}

func searchFrom(_ x: Int, _ y: Int) -> Int {
    guard charAt(x, y) == "X" else { return 0 }
    let xmas = "XMAS"
    var count: Int = 0
    var directions: [(Int, Int)] = [(1, 0), (0, 1), (-1, 0), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
    outerloop: while !directions.isEmpty {
        let (dirX, dirY) = directions.removeFirst()
        var currentPosition: (Int, Int) = (x, y)
        guard charAt(currentPosition.0, currentPosition.1) == "X" else { continue }
        for i in 1...3 {
            currentPosition.0 += dirX
            currentPosition.1 += dirY
            guard charAt(currentPosition.0, currentPosition.1) == xmas[xmas.index(xmas.startIndex, offsetBy: i)] else { continue outerloop }
        }
        count += 1
    }
    
    return count
}

func searchFromV2(_ x: Int, _ y: Int) -> Int {
    guard charAt(x, y) == "A" else { return 0 }
    
    switch charAt(x-1, y-1) {
    case "M":
        if(charAt(x+1, y+1) != "S") { return 0 }
    case "S":
        if(charAt(x+1, y+1) != "M") { return 0 }
    default: return 0
    }
    switch charAt(x+1, y-1) {
    case "M":
        if(charAt(x-1, y+1) != "S") { return 0 }
    case "S":
        if(charAt(x-1, y+1) != "M") { return 0 }
    default: return 0
    }
    
    return 1
}
