//
//  ContentView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 20/03/25.
//

import SwiftUI

let accentColor = UIColor(named: "AccentColor")

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                    .font(.headline)
            }
            .navigationTitle("Showcase")
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
