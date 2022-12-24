//
//  Bacteria.swift
//  BioBlitz
//
//  Created by Yuriy Lutsenko on 24.12.2022.
//

import SwiftUI

class Bacteria {
    enum Direction: CaseIterable {
        case north, south, east, west
        
        var rotation: Double {
            switch self {
            case .north: return 0
            case .east: return 90
            case .south: return 180
            case .west: return 270
            }
        }
        
        var opposite: Direction {
            switch self {
            case .north: return .south
            case .south: return .north
            case .east: return .west
            case .west: return .east
            }
        }
        
        var next: Direction {
            switch self {
            case .north: return .east
            case .east: return .south
            case .south: return .west
            case .west: return .north
            }
        }
    }
    
    var row: Int
    var column: Int
    
    var color = Color.gray
    var direction = Direction.north
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
