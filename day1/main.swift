//
//  main.swift
//  day1
//
//  Created by Johannes Loepelmann on 01.12.24.
//

import Foundation

var left: [Int] = []
var right: [Int] = []

let lines = try String.init(contentsOfFile: "/Users/sonix/Documents/dev/aoc2024/day1/day1.input", encoding: String.Encoding.utf8).split(separator: "\n")

for line in lines {
    let splits = line.split(separator: " ")
    left.append(Int(splits[0])!)
    right.append(Int(splits[1])!)
}

left.sort()
right.sort()

var distances: [Int] = []

for i in 0..<left.count {
    distances.append(abs(left[i] - right[i]))
}

let sum = distances.reduce(0, +)
print(sum)

var rightCounts: Dictionary<Int, Int> = Dictionary()

for i in 0..<right.count {
    rightCounts[right[i], default: 0] += 1
}

var result: Int = 0

for number in left {
    result += rightCounts[number, default: 0] * number
}

print(result)
