//
//  ContentView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct ContentView: View {
    var spherosNames: [String] = ["SB-A729", "SB-C7A8"] //SB-C7A8 - SB-42C1 - SB A729
    @State private var spherosAreConnected: Bool = false
    @ObservedObject var wsClient = WebSocketClient.shared
    @State var connectedToServer: Bool = false
    var body: some View {
        NavigationStack {
            if spherosAreConnected {
                SpheroControlView()
            }
            
            if !spherosAreConnected {
                Text("Spheros not connected")
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
                    self.spherosAreConnected = true
                }
            }
            
            let _ = SharedToyBox.instance.bolts.map{
                print("connected to sphero : \($0.identifier)")
            }
        }
        .onChange(of: wsClient.receivedMessage) {
            if spherosAreConnected && connectedToServer {
                print("Received message from server: \(wsClient.receivedMessage)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
