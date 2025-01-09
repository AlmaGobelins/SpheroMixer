//
//  SharedToyBox.swift
//  SpheroManager
//
//  Created by AL on 01/09/2019.
//  Copyright © 2019 AL. All rights reserved.
//

import Foundation

class SharedToyBox: ObservableObject {
    
    static let instance = SharedToyBox()
    
    private var searchCallBack:((Error?)->())?
    var onGyroData: ((ThreeAxisSensorData<Int>) -> Void)?
    var onOrientationData: ((AttitudeSensorData) -> Void)?
    var onAccelerometerData: ((ThreeAxisSensorData<Double>) -> Void)?
    
    @Published var spheroNamesConnected: [String] = []
    
    
    let box = ToyBox()
    var boltsNames = [String]()
    var bolts:[BoltToy] = []
    
    var bolt:BoltToy? {
        get {
            return bolts.first
        }
    }
    
    init() {
        box.addListener(self)
    }
    
    func searchForBoltsNamed(_ names:[String], doneCallBack:@escaping (Error?)->()) {
        searchCallBack = doneCallBack
        boltsNames = names
        box.start()
    }
    
    func stopScan() {
        box.stopScan()
    }
    
}

extension SharedToyBox:ToyBoxListener{
    func toyBoxReady(_ toyBox: ToyBox) {
        box.startScan()
    }
    
    func toyBox(_ toyBox: ToyBox, discovered descriptor: ToyDescriptor) {
        print("discovered \(descriptor.name)")
        
        if bolts.count >= boltsNames.count {
            box.stopScan()
        }else{
            if boltsNames.contains(descriptor.name ?? "") {
                let bolt = BoltToy(peripheral: descriptor.peripheral, owner: toyBox)
                bolts.append(bolt)
                toyBox.connect(toy: bolt)
            }
        }
        
    }
    
    func toyBox(_ toyBox: ToyBox, readied toy: Toy) {
        print("readied")
        if let b = toy as? BoltToy {
            print(b.peripheral?.name ?? "")
            
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Ajout du Sphero connecté au tableau
                if let name = b.peripheral?.name, !self.spheroNamesConnected.contains(name) {
                    self.spheroNamesConnected.append(name)
                    print("Sphero added: \(name). Current list: \(self.spheroNamesConnected)")
                }
            }
            
            if let i = self.bolts.firstIndex(where: { (item) -> Bool in
                item.identifier == b.identifier
            }){
                self.bolts[i] = b
            }
            
            if bolts.count >= boltsNames.count {
                DispatchQueue.main.async {
                    self.searchCallBack?(nil)
                }
            }
        }
    }
    
    func toyBox(_ toyBox: ToyBox, putAway toy: Toy) {
        print("put away")
    }
    
    
}

extension SharedToyBox {
    func startSensors() {
        let bolt = self.bolts[1]
        
        bolt.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer, .gyro, .orientation, .locator))
        bolt.sensorControl.interval = 100 // Mise à jour toutes les 100ms
        
        bolt.sensorControl.onDataReady = { [weak self] data in
            if let acceleroDatas = data.accelerometer?.filteredAcceleration {
                self?.onAccelerometerData?(acceleroDatas)
            }
            if let gyroDatas = data.gyro?.rotationRate {
                self?.onGyroData?(gyroDatas)
            }
            if let orientation = data.orientation {
                self?.onOrientationData?(orientation)
            }
        }
    }
}
