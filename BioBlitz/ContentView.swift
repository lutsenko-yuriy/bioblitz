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
                Text("GREEN: 0")
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("BIOBLITZ")
                
                Spacer()
                
                Text("RED: 0")
                    .foregroundColor(.red)
            }
            .font(.system(size: 36).weight(.black))
            
            VStack {
                ForEach(0..<11, id: \.self) { row in
                    HStack {
                        ForEach(0..<22, id: \.self) { column in
                            let bacteria = board.grid[row][column]
                            
                            BacteriaView(bacteria: bacteria) {
                                guard bacteria.color == .red || bacteria.color == .green else { return }
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
