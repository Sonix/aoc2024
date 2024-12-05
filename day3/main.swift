//
//  main.swift
//  day3
//
//  Created by Johannes Loepelmann on 05.12.24.
//

import Foundation

let input = linesFromFile("day3/day3.input").joined()
let regex = /mul\((\d{1,3}),(\d{1,3})\)/
let validInstructions = input.matches(of: regex).map {input[$0.range].wholeMatch(of: regex).map {[Int($0.1), Int($0.2)]}}
print("Result : \(validInstructions.reduce(0, {$0 + $1![0]! * $1![1]! }))")


let dos = input.matches(of: /do\(\)/)
let donts = input.matches(of: /don't\(\)/)

let dontStarts = donts.map(\.0.startIndex)
let doEnds = dos.map(\.0.endIndex)

var i = input.startIndex
var ranges: [Range<String.Index>] = []
var lastDontStart = dontStarts[0]
while i < input.endIndex {
    ranges.append(i..<lastDontStart)
    i = doEnds.first { $0 > lastDontStart } ?? input.endIndex
    lastDontStart = dontStarts.first { $0 > i } ?? input.endIndex
}
let input2 = ranges.map { input[$0] }.joined()
let validInstructions2 = input2.matches(of: regex).map {input2[$0.range].wholeMatch(of: regex).map {[Int($0.1), Int($0.2)]}}
print("Result2 : \(validInstructions2.reduce(0, {$0 + $1![0]! * $1![1]! }))")
