//
//  SpheroControlView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct SpheroControlView: View {
    private var controller = SpheroRotationController(bolt: SharedToyBox.instance.bolts[0])
    private let flipDetector = FlipDetector(toyBox: SharedToyBox.instance)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Contrôle mixeur")
               .font(.title)
               .padding()
               .foregroundColor(.white)
               .cornerRadius(10)
               .onChange(of: WebSocketClient.shared.receivedMessage) {
                   controller.goFullSpeedAhead(duration: 5.0) //Max value is 255 for speed
               }
        }
        .padding()
    }
}

#Preview {
    SpheroControlView()
}
