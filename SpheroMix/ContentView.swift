//
//  ContentView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct ContentView: View {
    var spherosNames: [String] = ["SB-42C1"] //SB-C7A8 - SB-42C1
    @State private var spheroIsConnected: Bool = false
    @ObservedObject var wsClient = WebSocketClient.shared
    @State var connectedToServer: Bool = false
    var body: some View {
        VStack {
            if spheroIsConnected {
                SpheroControlView()
            }
            
            if !spheroIsConnected {
                Text("Sphero not connected")
            }
            
            if !connectedToServer {
                Text("Not connected to WS Server")
            }
        }
        .onAppear {
            connectedToServer = wsClient.connectTo(route:"phoneMixer")
            wsClient.sendMessage("Phone sends hello from \(UIDevice.current.name)", toRoute: "phoneMixer")
            SharedToyBox.instance.searchForBoltsNamed(spherosNames) { err in
                if err == nil {
                    print("Connected to sphero")
                    self.spheroIsConnected.toggle()
                }
            }
        }
        .onChange(of: wsClient.receivedMessage) {
            if spheroIsConnected && connectedToServer {
                print("Received message from server: \(wsClient.receivedMessage)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
