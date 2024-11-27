//
//  SpheroControlView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct SpheroControlView: View {
    private var controller = SpheroRotationController(bolt: SharedToyBox.instance.bolts[0])
    
    var body: some View {
        VStack(spacing: 20) {
           Button(action: { controller.rotateInPlace(duration: 5.0, speed: 128) }) {
               Text("Start spinning")
                   .font(.title)
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
        }
        .padding()
    }
}

#Preview {
    SpheroControlView()
}
