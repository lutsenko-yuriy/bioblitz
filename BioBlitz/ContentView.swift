//
//  ContentView.swift
//  BioBlitz
//
//  Created by Yuriy Lutsenko on 24.12.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var board = GameBoard()
    
    var body: some View {
        VStack {
            HStack {
                Text("GREEN: \(board.greenScore)")
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(.green)
                            .opacity(board.currentPlayer == .green ? 1 : 0)
                    )
                
                Spacer()
                
                Text("RESET")
                    .onTapGesture {
                        board.reset()
                    }
                
                Spacer()
                
                Text("RED: \(board.redScore)")
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(.red)
                            .opacity(board.currentPlayer == .red ? 1 : 0)
                    )
            }
            .font(.system(size: 36).weight(.black))
            
            VStack {
                ForEach(0..<11, id: \.self) { row in
                    HStack {
                        ForEach(0..<22, id: \.self) { column in
                            let bacteria = board.grid[row][column]
                            
                            BacteriaView(bacteria: bacteria) {
                                board.rotate(bacteria: bacteria)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .fixedSize()
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
