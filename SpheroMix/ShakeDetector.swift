//
//  ShakeDetector.swift
//  SpheroMix
//
//  Created by Mathieu Dubart on 28/11/2024.
//

import SwiftUI

class ShakeDetector {
    private let shakeThreshold: Double = 0.9 // À ajuster selon la sensibilité souhaitée
    var bolt: BoltToy
    
    private var lastX: Double = 0.0
    private var lastY: Double = 0.0
    private var lastZ: Double = 0.0
    private var isCheckingShake = false
    
    var onShakeDetected: (() -> Void)?
    
    init(bolt: BoltToy) {
        self.bolt = bolt
        bolt.setFrontLed(color: .red)
        bolt.setBackLed(color: .red)
        bolt.setMainLed(color: .red)
    }
    
    func startMonitoring() {
        bolt.sensorControl.enable(sensors: [.accelerometer])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.bolt.sensorControl.onDataReady = { [weak self] data in
                if let acceleroDatas = data.accelerometer?.filteredAcceleration {
                    self?.processAccelData(acceleroDatas)
                }
            }
        }
    }
    
    private func processAccelData(_ accelData: ThreeAxisSensorData<Double>) {
        guard let x = accelData.x,
              let y = accelData.y,
              let z = accelData.z else { return }
        
        // Si on est déjà en train de vérifier un shake, on ignore
        if isCheckingShake {
            return
        }
        
        // Calculer le changement d'accélération
        let deltaX = abs(x - lastX)
        let deltaY = abs(y - lastY)
        let deltaZ = abs(z - lastZ)
        
        // Mettre à jour les dernières valeurs
        lastX = x
        lastY = y
        lastZ = z
        
        // Vérifier si le changement est assez important
        if (deltaX > shakeThreshold ||
            deltaY > shakeThreshold ||
            deltaZ > shakeThreshold) {
            
            isCheckingShake = true
            print("SHAKE DÉTECTÉ! Delta X: \(deltaX), Delta Y: \(deltaY), Delta Z: \(deltaZ)")
            onShakeDetected?()
            
            // Réinitialiser après un délai
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.isCheckingShake = false
            }
        }
    }
}
