//
//  utils.swift
//  aoc2024
//
//  Created by Johannes Loepelmann on 04.12.24.
//

func linesFromFile(_ file: String) -> [String.SubSequence] {
    return try! String.init(contentsOfFile: "/Users/sonix/Documents/dev/aoc2024/\(file)", encoding: String.Encoding.utf8).split(separator: "\n")
}
