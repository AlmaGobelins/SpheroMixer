//
//  ContentView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct ContentView: View {
    var spherosNames: [String] = ["SB-C7A8"]
    @State private var spheroIsConnected: Bool = false
    @ObservedObject var wsClient = WebSocketClient.shared
    @State var connectedToServer: Bool = false
    var body: some View {
        VStack {
            if !spheroIsConnected {
                Button("Connect") {
                    SharedToyBox.instance.searchForBoltsNamed(spherosNames) { err in
                        if err == nil {
                            print("Connected")
                            self.spheroIsConnected.toggle()
                        }
                    }
                }
            }
            
            if spheroIsConnected {
                SpheroControlView()
            }
        }
        .onAppear {
            connectedToServer = wsClient.connectTo(route:"mixer")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
