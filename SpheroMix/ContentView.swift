//
//  ContentView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct ContentView: View {
    var spherosNames: [String] = ["SB-A729", "SB-C7A8"]
    @State private var spheroIsConnected: Bool = false
    @State private var displayView: Bool = false
    @State private var connectedSpheros: [String] = [] // État pour stocker les noms des Spheros connectés
    
    @ObservedObject var wsClient = WebSocketClient.shared
    @ObservedObject var sharedToyBox = SharedToyBox.instance

    
    var body: some View {
        VStack {
            if displayView {
                SpheroControlView()
            } else {
                Button("Connecter mixer") {
                    self.displayView.toggle()
                }
                
                // Liste des Spheros connectés
                if !sharedToyBox.spheroNamesConnected.isEmpty {
                    Text("Connected Spheros:")
                        .font(.headline)
                    ForEach(sharedToyBox.spheroNamesConnected, id: \.self) { spheroName in
                        Text(spheroName)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                } else {
                    Text("No Spheros connected")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            let _ = wsClient.connectTo(route: "phoneMix")
            
            SharedToyBox.instance.searchForBoltsNamed(spherosNames) { err in
                if err == nil {
                    print("Connected to Sphero")
                } else {
                    print("Error connecting to Spheros: \(err?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        .onChange(of: sharedToyBox.spheroNamesConnected) { newValue, _ in
            connectedSpheros = newValue
            wsClient.sendMessage("Spheros connected: \(newValue)", toRoute: "phoneMix")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
