//
//  ContentView.swift
//  FB-ABTest
//
//  Created by Jinwoo Kim on 11/26/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ContentViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Received: \(viewModel.receivedValue ?? "nil")")
                .font(.system(size: 20))
                .padding()
            Button("Log") {
                viewModel.sendLog()
            }
            .padding()
            Button("Remote Config") {
                viewModel.configure()
                viewModel.fetchRemoteConfigEvent()
            }
            .padding()
            Button("A/B Test") {
                viewModel.configure()
                viewModel.fetchABTestEvent()
            }
            .padding()
            Button("Clear") {
                viewModel.receivedValue = nil
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
