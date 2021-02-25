//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Brandon Knox on 2/24/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: {
            print("Button was tapped")
        }) {
            Image(systemName: "pencil")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
