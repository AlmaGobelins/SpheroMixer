//
//  ContentView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct ContentView: View {
    var spherosNames: [String] = ["SB-C7A8", "SB-42C1"] //SB-C7A8 - SB-42C1 - SB-A729 - SB-2020
    @State private var spheroIsConnected: Bool = false
    @State private var displayView: Bool = false
    
    @ObservedObject var wsClient = WebSocketClient.shared
    var body: some View {
        VStack {
            if displayView {
                SpheroControlView()
            }
            
            if !displayView {
                Button("Display view") {
                    self.displayView.toggle()
                }
            }
            
        }
        .onAppear {
//            connectedToServer = wsClient.connectTo(route:"phoneMixer")
//            wsClient.sendMessage("Phone sends hello from \(UIDevice.current.name)", toRoute: "phoneMixer")
            SharedToyBox.instance.searchForBoltsNamed(spherosNames) { err in
                if err == nil {
                    print("Connected to sphero")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
