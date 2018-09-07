//
//  KeyboardConstants.swift
//  SNSGeldmaatje
//
//  Created by Maiko Hermans on 05/06/2018.
//  Copyright © 2018 dtt. All rights reserved.
//

import Foundation

/// ❌ The error types.
///
/// - noLocalAuthorize: Error for no biometrics being present on the device.
enum Errors: Int {
    case noLocalAuthorize = -7
}

/// 🔓 The possible unlocked states of the device based on the biometrics present on the device.
///
/// - noLocalAuthorize: no biometrics present on the device or not enrolled.
/// - localAuthorizeSuccess: successfull authorization of the device using biometrics.
/// - localAuthorizeFailed: unsuccessfull authoriation of the device using biometrics.
public enum UnlockState {
    case noLocalAuthorize
    case localAuthorizeSuccess
    case localAuthorizeFailed
}
