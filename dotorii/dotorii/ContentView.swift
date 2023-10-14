//
//  ContentView.swift
//  dotorii
//
//  Created by Yunseo Lee on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.blue)
            
            Text("Welcome to FinSight")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Button(action: {
                // Add action for the button
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
