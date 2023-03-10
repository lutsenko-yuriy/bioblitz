//
//  GameBoard.swift
//  BioBlitz
//
//  Created by Yuriy Lutsenko on 24.12.2022.
//

import SwiftUI

class GameBoard: ObservableObject {
    let rowCount = 11
    let columnCount = 22
    
    @Published var grid = [[Bacteria]]()
    
    @Published var currentPlayer = Color.green
    @Published var greenScore = 1
    @Published var redScore = 1
    @Published var gameOver = false
    
    private var bacteriaBeingInfected = 0
    
    init() {
        reset()
    }
    
    func reset() {
        grid.removeAll()
        
        for row in 0..<rowCount {
            var newRow = [Bacteria]()
            
            for column in 0..<columnCount {
                let bacteria = Bacteria(row: row, column: column)
                
                if row <= rowCount / 2 {
                    if row == 0 && column == 0 {
                        bacteria.direction = .north
                    } else if row == 0 && column == 1 {
                        bacteria.direction = .east
                    } else if row == 1 && column == 0 {
                        bacteria.direction = .south
                    } else {
                        bacteria.direction = Bacteria.Direction.allCases.randomElement()!
                    }
                } else {
                    if let counterpart = getBacteria(atRow: rowCount - 1 - row, column: columnCount - 1 - column) {
                        bacteria.direction = counterpart.direction.opposite
                    }
                }
                newRow.append(bacteria)
            }
            
            grid.append(newRow)
            
            redScore = 1
            greenScore = 1
            gameOver = false
            currentPlayer = .green
        }
        
        grid[0][0].color = .green
        grid[rowCount - 1][columnCount - 1].color = .red
    }
    
    func getBacteria(atRow row: Int, column: Int) -> Bacteria? {
        guard row >= 0, row < grid.count else { return nil }
        guard column >= 0, column < grid[0].count else { return nil }
        
        return grid[row][column]
    }
    
    func infect(from source: Bacteria) {
        objectWillChange.send()
        
        var bacteriaToInfect = [Bacteria?]()
        
        switch source.direction {
        case .north:
            bacteriaToInfect.append(getBacteria(atRow: source.row - 1, column: source.column))
        case .south:
            bacteriaToInfect.append(getBacteria(atRow: source.row + 1, column: source.column))
        case .east:
            bacteriaToInfect.append(getBacteria(atRow: source.row, column: source.column + 1))
        case .west:
            bacteriaToInfect.append(getBacteria(atRow: source.row, column: source.column - 1))
        }
        
        if let indirect = getBacteria(atRow: source.row - 1, column: source.column) {
            if indirect.direction == .south {
                bacteriaToInfect.append(indirect)
            }
        }
        
        if let indirect = getBacteria(atRow: source.row + 1, column: source.column) {
            if indirect.direction == .north {
                bacteriaToInfect.append(indirect)
            }
        }
        
        if let indirect = getBacteria(atRow: source.row, column: source.column - 1) {
            if indirect.direction == .east {
                bacteriaToInfect.append(indirect)
            }
        }
        
        if let indirect = getBacteria(atRow: source.row, column: source.column + 1) {
            if indirect.direction == .west {
                bacteriaToInfect.append(indirect)
            }
        }
        
        for case let bacteria? in bacteriaToInfect {
            if bacteria.color != source.color {
                bacteria.color = source.color
                bacteriaBeingInfected += 1
                
                Task { @MainActor in
                    try await Task.sleep(nanoseconds: 50_000_000)
                    bacteriaBeingInfected -= 1
                    infect(from: bacteria)
                }
            }
        }
        
        updateScores()
    }
    
    func rotate(bacteria: Bacteria) {
        guard bacteriaBeingInfected == 0 else { return }
        guard bacteria.color == currentPlayer else { return }
        
        objectWillChange.send()
        
        bacteria.direction = bacteria.direction.next
        
        infect(from: bacteria)
    }
    
    func changePlayer() {
        if currentPlayer == .green {
            currentPlayer = .red
        } else if currentPlayer == .red {
            currentPlayer = .green
        }
    }
    
    func updateScores() {
        var newRedScore = 0
        var newGreenScore = 0
        
        for row in grid {
            for bacteria in row {
                if bacteria.color == .red {
                    newRedScore += 1
                } else if bacteria.color == .green {
                    newGreenScore += 1
                }
            }
        }
        
        redScore = newRedScore
        greenScore = newGreenScore
        
        if bacteriaBeingInfected == 0 {
            withAnimation(.spring() ) {
                if redScore == 0 || greenScore == 0 {
                    gameOver = true
                } else {
                    changePlayer()
                }
            }
        }
    }
}
