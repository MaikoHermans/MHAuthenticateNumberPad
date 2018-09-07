//
//  UnlockManager.swift
//  SNSGeldmaatje
//
//  Created by Maiko Hermans on 05/06/2018.
//  Copyright © 2018 dtt. All rights reserved.
//

import Foundation
import LocalAuthentication

/// 📚 Manager for Authorizing with the biometrics available on the device.
class UnlockingManager {
    
    static func authenticate(unlockReason: String, completion: @escaping (_ result: Bool, _ error: Error?) -> ()){
        let context = LAContext()
        let reason = unlockReason
        
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        } else {
            completion(false, authError)
        }
    }
    
    /// Check which biometric functions are available on the device.
    ///
    /// - Returns: The type of biometrics and/or an error.
    static func checkBiometrics() -> (biometricsType: LABiometryType, error: NSError?) {
        let context = LAContext()
        
        var authError: NSError?
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        
        return (context.biometryType, authError)
    }
    
}
