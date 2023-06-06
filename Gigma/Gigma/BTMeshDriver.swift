//
//  BTMeshDriver.swift
//  Gigma
//
//  Created by Jake Chong on 06/06/2023.
//

import UIKit
import nRFMeshProvision

@objc class BTMeshDriver : NSObject, BluetoothDriver, LoggerDelegate  {
    
    var meshNetworkManager: MeshNetworkManager!
    var connection: NetworkConnection!
    
    func log(message: String, ofCategory category: nRFMeshProvision.LogCategory, withLevel level: nRFMeshProvision.LogLevel) {
        print(level, message)
    }
    
    override init() {
        super.init()
        
        meshNetworkManager = MeshNetworkManager()
        meshNetworkManager.acknowledgmentTimerInterval = 0.150
        meshNetworkManager.transmissionTimerInterval = 0.600
        meshNetworkManager.incompleteMessageTimeout = 10.0
        meshNetworkManager.retransmissionLimit = 2
        meshNetworkManager.acknowledgmentMessageInterval = 4.2
        meshNetworkManager.acknowledgmentMessageTimeout = 40.0
        meshNetworkManager.logger = self
        
        do {
            if try meshNetworkManager.load() {
                meshNetworkDidChange()
            }
            else {
                _ = createNewMeshNetwork()
            }
        } catch {
            print(error)
        }
    }
    
    func createNewMeshNetwork() -> MeshNetwork {
        let provisioner = Provisioner(name: UIDevice.current.name,
                                      allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
                                      allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
                                      allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
        let network = meshNetworkManager.createNewMeshNetwork(withName: "nRF Mesh Network", by: provisioner)
        _ = meshNetworkManager.save()

        meshNetworkDidChange()
        return network
    }
    
    func meshNetworkDidChange() {
        connection?.close()
        
        let meshNetwork = meshNetworkManager.meshNetwork!

        // Generic Default Transition Time Server model:
        let defaultTransitionTimeServerDelegate = GenericDefaultTransitionTimeServerDelegate(meshNetwork)
        // Scene Server and Scene Setup Server models:
        let sceneServer = SceneServerDelegate(meshNetwork,
                                              defaultTransitionTimeServer: defaultTransitionTimeServerDelegate)
        let sceneSetupServer = SceneSetupServerDelegate(server: sceneServer)
        
        
        connection = NetworkConnection(to: meshNetwork)
        connection!.dataDelegate = meshNetworkManager
        connection!.logger = self
        meshNetworkManager.transmitter = connection
        connection!.open()
    }
    
    func nearbyBluetoothDevices() -> [NSUUID : NSString] {
        <#code#>
    }
    
    func getLocation(uuid: NSUUID) -> CodableCoordinate {
        <#code#>
    }
}
    
    
    

