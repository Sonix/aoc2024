//
//  main.swift
//  day6
//
//  Created by Johannes Loepelmann on 06.12.24.
//

import Foundation

let lines = linesFromFile("day6/day6.input")
let map: [[Character]] = lines.map { Array($0) }

var paintedMap = paintMap(map)

print("Result : \(paintedMap.reduce(0) { $0 + $1.count(where: {char in char == "X"})})")

var total = 0

for y in 0..<map.count {
    for x in 0..<map[y].count {
        if createsLoop(obstacleAt: (x, y), map) {
            total += 1
        }
    }
}

print("Result : \(total)")

enum Direction {
    case north
    case south
    case east
    case west
}

func createsLoop(obstacleAt: (Int, Int),_ map: [[Character]]) -> Bool {
    guard map.charAt(obstacleAt.0, obstacleAt.1) == "." else { return false }
    var derivedMap = map
    derivedMap[obstacleAt.1][obstacleAt.0] = "#"
    
    var currentPosition: (Int, Int) = map.startingPoint()!
    var currentDirection = Direction.north
    var paintedMap = derivedMap
    paintedMap[currentPosition.1][currentPosition.0] = "."
    
    while true {
        var nextPosition: (Int, Int)
        switch currentDirection {
        case .north:
            nextPosition = (currentPosition.0, currentPosition.1 - 1)
        case .south:
            nextPosition = (currentPosition.0, currentPosition.1 + 1)
        case .east:
            nextPosition = (currentPosition.0 + 1, currentPosition.1)
        case .west:
            nextPosition = (currentPosition.0 - 1, currentPosition.1)
        }
        
        let nextTile = paintedMap.charAt(nextPosition.0, nextPosition.1)
        if nextTile == nil {
            return false
        }
        
        if nextTile == "#" {
            switch currentDirection {
            case .north:
                currentDirection = .east
            case .south:
                currentDirection = .west
            case .east:
                currentDirection = .south
            case .west:
                currentDirection = .north
            }
            
            continue
        }
                
        var nextDirectionTile: Character
        switch currentDirection {
        case .north:
            nextDirectionTile = "^"
        case .south:
            nextDirectionTile = "v"
        case .east:
            nextDirectionTile = ">"
        case .west:
            nextDirectionTile = "<"
        }
        
        if(paintedMap[currentPosition.1][currentPosition.0] == nextDirectionTile) {
            return true
        }
        
        paintedMap[currentPosition.1][currentPosition.0] = nextDirectionTile
        currentPosition = nextPosition
    }
    
    return false
}

func paintMap(_ map: [[Character]]) -> [[Character]] {
    var currentPosition: (Int, Int) = map.startingPoint()!
    var currentDirection = Direction.north
    var paintedMap = map
    
    while true {
        var nextPosition: (Int, Int)
        switch currentDirection {
        case .north:
            nextPosition = (currentPosition.0, currentPosition.1 - 1)
        case .south:
            nextPosition = (currentPosition.0, currentPosition.1 + 1)
        case .east:
            nextPosition = (currentPosition.0 + 1, currentPosition.1)
        case .west:
            nextPosition = (currentPosition.0 - 1, currentPosition.1)
        }
        
        let nextTile = map.charAt(nextPosition.0, nextPosition.1)
        if nextTile == nil {
            paintedMap[currentPosition.1][currentPosition.0] = "X"
            break
        }
        
        if nextTile == "#" {
            switch currentDirection {
            case .north:
                currentDirection = .east
            case .south:
                currentDirection = .west
            case .east:
                currentDirection = .south
            case .west:
                currentDirection = .north
            }
            
            continue
        }
        
        paintedMap[currentPosition.1][currentPosition.0] = "X"
        currentPosition = nextPosition
    }
    
    return paintedMap
}

extension Array where Element == [Character] {
    func charAt(_ x: Int, _ y: Int) -> Character? {
        guard y >= 0 && y < self.count, x >= 0 && x < self[y].count else { return nil }
        return self[y][x]
    }
    
    func startingPoint() -> (Int, Int)? {
        guard let y = self.firstIndex(where: { $0.contains("^")}) else { return nil }
        guard let x = self[y].firstIndex(of: "^") else { return nil }
        return (x, y)
    }
    
    func print() {
        for row in self {
            Swift.print(String(row))
        }
    }
}
