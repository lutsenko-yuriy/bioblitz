//
//  ContentView.swift
//  BioBlitz
//
//  Created by Yuriy Lutsenko on 24.12.2022.
//

import SwiftUI

struct ContentView: View {
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
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
