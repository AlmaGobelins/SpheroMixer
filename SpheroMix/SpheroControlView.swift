//
//  SpheroControlView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct SpheroControlView: View {
    private var controller = SpheroRotationController(bolt: SharedToyBox.instance.bolts[0]) // color: blue
    private let shakeDetector = ShakeDetector(bolt: SharedToyBox.instance.bolts[SharedToyBox.instance.bolts.count-1]) // color: red
    @ObservedObject var wsClient = WebSocketClient.shared

    
    var body: some View {
        VStack(spacing: 20) {
            Text("Contrôle mixeur")
               .font(.title)
               .padding()
               .foregroundColor(.primary)
               .cornerRadius(10)
        }
        .padding()
        .onChange(of: wsClient.toggleMix) { newValue, _ in
            print("wsClient.toggleMix: \(newValue)")
            let duration = 5.0
            controller.goFullSpeedAhead(duration: duration)
            
            // Set toggleMix to false after the duration ends
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                wsClient.toggleMix = false
            }
        }
        .onAppear {
            self.shakeDetector.onShakeDetected = {
                controller.goFullSpeedAhead(duration: 1.0)
            }
            
            self.shakeDetector.startMonitoring()
        }
    }
}

#Preview {
    SpheroControlView()
}
