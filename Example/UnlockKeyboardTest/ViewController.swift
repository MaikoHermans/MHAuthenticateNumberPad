//
//  ViewController.swift
//  UnlockKeyboardTest
//
//  Created by Maiko Hermans on 27/06/2018.
//  Copyright © 2018 mhdevelopment. All rights reserved.
//

import UIKit
import MHAuthenticateNumberPad

class ViewController: UIViewController {
    @IBOutlet weak var numberPadTextField: UITextField!
    @IBOutlet weak var biometricsNumberPadTextField: UITextField!
    
    /// The keyboard that's being used for the UITextField that shouldn't have the biometric option.
    private lazy var numberPadKeyboard: AuthenticateKeyboard = {
        let keyboard = AuthenticateKeyboard(editingTextField: numberPadTextField)
        keyboard.useBiometrics = false
        return keyboard
    }()
    
    /// The keyboard that's being used for the UITextField that should have the biometric option.
    private lazy var biometricsNumberPadKeyboard: AuthenticateKeyboard = {
        let keyboard = AuthenticateKeyboard(editingTextField: biometricsNumberPadTextField)
        keyboard.delegate = self
        return keyboard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        numberPadTextField.inputView = numberPadKeyboard
        biometricsNumberPadTextField.inputView = biometricsNumberPadKeyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Authenticate Keyboard Delegate Methods.
extension ViewController: AuthenticateKeyboardDelegate {
    
    // Check the result of the authentication using biometrics.
    func didAuthenticate(_ result: UnlockState) {
        var authStatus: String!
        switch result {
        case .localAuthorizeFailed, .noLocalAuthorize:
            authStatus = "Couldn't authorize you using biometrics."
        case .localAuthorizeSuccess:
            authStatus = "Authorized you using biometrics."
        }
        
        let alert = UIAlertController(title: "Biometrics Authorization", message: authStatus, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
