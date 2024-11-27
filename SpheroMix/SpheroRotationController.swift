//
//  SpheroRotationController.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 27/11/2024.
//

import SwiftUI

class SpheroRotationController {
    var bolt: BoltToy?
    private var timer: Timer?
    
    init(bolt: BoltToy? = nil) {
        self.bolt = bolt
    }
    
    func rotateInPlace(duration: TimeInterval, speed: Float) {
        guard let bolt = bolt else {
            print("Sphero non connecté")
            return
        }
        
        // Désactiver la stabilisation
        bolt.setStabilization(state: .off)
        
        // Pour faire tourner sur place, on utilise roll avec une vitesse de 0
        // mais on fait varier le heading en continu
        var currentHeading: Float = 0
        
        // Créer un timer qui met à jour le heading rapidement
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            currentHeading += 255 // Ajuster la vitesse de rotation
            if currentHeading >= 360 {
                currentHeading -= 360
            }
            
            // Utiliser roll avec vitesse 0 mais en changeant le heading
            bolt.roll(heading: Double(currentHeading), speed: 0)
        }
        
        // Créer un timer pour arrêter la rotation après la durée spécifiée
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stopRotation()
        }
    }
    
    func stopRotation() {
        guard let bolt = bolt else { return }
        
        timer?.invalidate()
        timer = nil
        
        // Arrêter la rotation
        bolt.roll(heading: 0, speed: 0)
        
        // Réactiver la stabilisation
        bolt.setStabilization(state: .off)
    }
}
