//
//  main.swift
//  day9
//
//  Created by Johannes Loepelmann on 09.12.24.
//

import Foundation


enum Block : CustomStringConvertible, Equatable {
    case empty
    case file(Int)
    
    var description: String {
        switch self {
        case .empty: return "."
        case .file(let value): return String(value)
        }
    }
}

extension Array where Element == Block {
    
    func defragmented() -> [Block] {
        var disk = self
        
        var firstFreeIndex = disk.firstIndex(of: .empty)!
        var currentIndex = disk.lastIndex(where: { $0 != .empty })!
        
        while currentIndex > 0 && currentIndex > firstFreeIndex {
            
            disk[firstFreeIndex] = disk[currentIndex]
            disk[currentIndex] = .empty
            
            firstFreeIndex += 1
            while firstFreeIndex < disk.endIndex && disk[firstFreeIndex] != .empty {
                firstFreeIndex += 1
            }
            
            currentIndex -= 1
            while currentIndex < disk.endIndex && disk[currentIndex] == .empty {
                currentIndex -= 1
            }
        }
        
        return disk
    }
    
    func defragmentFullFiles() -> [Block] {
        var disk = self
        
        var firstFreeIndex = disk.firstIndex(of: .empty)!
        
        var currentIndex = disk.lastIndex(where: { $0 != .empty })!
        var currentLength = 1
        var currentId = 0;
        switch disk[currentIndex] {
            case .file(let value): currentId = value
            case .empty: break
        }
        
        while(currentIndex > 0) {
            currentIndex -= 1
            switch disk[currentIndex] {
            case .file(let value):
                if value == currentId {
                    currentLength += 1
                    continue
                }
            case .empty: ()
            }
            
            
            if disk[firstFreeIndex] != .empty {
                while firstFreeIndex < disk.endIndex && disk[firstFreeIndex] != .empty {
                    firstFreeIndex += 1
                }
            }
            
            var freeLength = 1
            var currentFreeIndex = firstFreeIndex
            while currentFreeIndex < disk.endIndex && currentFreeIndex <= currentIndex {
                var nextFreeIndex = currentFreeIndex + 1
                while nextFreeIndex < disk.endIndex && disk[nextFreeIndex] == .empty && freeLength < currentLength {
                    freeLength += 1
                    nextFreeIndex += 1
                }
                
                if freeLength == currentLength {
                    while currentLength > 0 {
                        disk[currentFreeIndex] = .file(currentId)
                        disk[currentIndex + currentLength] = .empty
                        currentFreeIndex += 1
                        currentLength -= 1
                    }
                    
                    break
                    
                } else {
                    currentFreeIndex = nextFreeIndex
                    while currentFreeIndex < disk.endIndex && disk[currentFreeIndex] != .empty {
                        currentFreeIndex += 1
                    }
                    freeLength = 1
                }
            }
            
            if currentFreeIndex == disk.endIndex || currentFreeIndex == currentIndex {
                while currentIndex > 0 && disk[currentIndex] == .empty {
                    currentIndex -= 1
                }
            }
            
            loop: while currentIndex > 0 {
                switch disk[currentIndex] {
                    case .file(let value):
                    if value > currentId {
                        currentIndex -= 1
                    } else {
                        currentId = value
                        break loop
                    }
                    case .empty:
                    currentIndex -= 1
                }
            }
            
            currentLength = 1
        }
        
        return disk
    }
    
    var description: String {
        map(\.description).joined()
    }
    
    var checksum: Int {
        var result: Int = 0
        for i in 0..<self.count {
            let currentBlock = self[i]
            switch currentBlock {
            case .file(let value): result += value * i
            case .empty: result += 0
            }
        }
        
        return result
    }
}

let input = linesFromFile("day9/day9.input")[0]

var disk: [Block] = []
var i = 0

for char in input {
    if i % 2 == 0 {
        disk.append(contentsOf: Array(repeating: .file(i / 2), count: char.wholeNumberValue!))
    } else {
        disk.append(contentsOf: Array(repeating: .empty, count: char.wholeNumberValue!))
    }
    
    i += 1
}

print(disk.description)

let defragmented = disk.defragmented()

print(defragmented.description)
print(defragmented.checksum)

let defragmentedFullFile = disk.defragmentFullFiles()
print(defragmentedFullFile.description)
print(defragmentedFullFile.checksum)
