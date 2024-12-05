//
//  SpheroRotationController.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

class SpheroRotationController {
    var bolt: BoltToy
    private var timer: Timer?
    
    init(bolt: BoltToy) {
        bolt.setFrontLed(color: .blue)
        bolt.setBackLed(color: .blue)
        bolt.setMainLed(color: .blue)
        self.bolt = bolt
    }
    
    func goFullSpeedAhead(duration: TimeInterval) {
        
        // Désactiver la stabilisation
        bolt.setStabilization(state: .off)
        
        // Faire rouler le Sphero à pleine vitesse dans une direction fixe (0 degrés)
        bolt.roll(heading: 0, speed: 255)
        
        // Créer un timer pour arrêter le mouvement après la durée spécifiée
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stop()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        
        // Arrêter le mouvement
        bolt.roll(heading: 0, speed: 0)
        
        // Réactiver la stabilisation
        bolt.setStabilization(state: .off)
    }
}

