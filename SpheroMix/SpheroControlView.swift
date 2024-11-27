//
//  SpheroControlView.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

struct SpheroControlView: View {
    private var controller = SpheroRotationController(bolt: SharedToyBox.instance.bolts[0])
    @State private var date = Date.now
    var body: some View {
        VStack(spacing: 20) {
            Text("\(date.formatted())")
               .font(.title)
               .padding()
               .background(Color.blue)
               .foregroundColor(.white)
               .cornerRadius(10)
               .onChange(of: WebSocketClient.shared.receivedMessage) {
                   self.date = Date.now
               }
        }
        .padding()
    }
}

#Preview {
    SpheroControlView()
}
