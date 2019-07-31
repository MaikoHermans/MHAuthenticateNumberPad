
import UIKit
import IQKeyboardManager
import LocalAuthentication

/// ⌨️ Keyboard Delegate.
public protocol AuthenticateKeyboardDelegate: class {
    func didAuthenticate(_ result: UnlockState)
}

/// ⌨️ The Keyboard which displays the Keys the keyboards biometric functionalities.
public class AuthenticateKeyboard: BaseView {
    @IBOutlet private var rowOneButtons: [Key]!
    @IBOutlet private var rowTwoButtons: [Key]!
    @IBOutlet private var rowThreeButtons: [Key]!
    @IBOutlet private var rowFourButtons: [Key]!
    @IBOutlet private weak var keyContainer: UIView!
    
    /// holds all the rows for the keyboard, each row holds three keys.
    private lazy var allRows = {
        [rowOneButtons, rowTwoButtons, rowThreeButtons, rowFourButtons]
    }()
    /// The constraints for the container of the keys when the device is in portrait orientation.
    private var keyContainerPortraitConstraints: [NSLayoutConstraint] = []
    /// The constraints for the container of the keys when the device is in landscape orientation.
    private var keyContainerLandscapeConstraints: [NSLayoutConstraint] = []
    
    /// The delegate for the Keyboard.
    public weak var delegate: AuthenticateKeyboardDelegate?
    /// Specify whether the keyboard needs to be able to perform biometric capabilities or not.
    public var useBiometrics: Bool = true { didSet { initKeyBoard() } }
    
    /// The textfield which is being edited by the keyboard.
    private var editingTextField: UITextField!
    
    /// initialize the keyboard with the field that is being edited by the keyboard.
    ///
    /// - Parameter editingTextField: The UITextField that is being edited by the keyboard.
    public init(editingTextField: UITextField) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIWindow().screen.bounds.width, height: 200))
        
        self.editingTextField = editingTextField
        autoresizingMask = .flexibleHeight
        
        initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    deinit {
        IQKeyboardManager.shared().previousNextDisplayMode = .default
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        rowOneButtons.forEach { $0.setNeedsDisplay() }
        rowTwoButtons.forEach { $0.setNeedsDisplay() }
        rowThreeButtons.forEach { $0.setNeedsDisplay() }
        rowFourButtons.forEach { $0.setNeedsDisplay() }
        
        switchConstraints()
    }
    
    /// Initialize view properties.
    private func initView() {
        rowOneButtons.sort { $0.tag < $1.tag }
        rowTwoButtons.sort { $0.tag < $1.tag }
        rowThreeButtons.sort { $0.tag < $1.tag }
        rowFourButtons.sort { $0.tag < $1.tag }
        
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        
        createConstraints()
        
        initKeyBoard()
    }
    
    /// Set the values for the keys.
    private func initKeyBoard() {
        allRows.forEach { $0?.forEach { $0.delegate = self } }
        
        rowOneButtons[0].value = "1"
        rowOneButtons[1].value = "2"
        rowOneButtons[2].value = "3"
        
        rowTwoButtons[0].value = "4"
        rowTwoButtons[1].value = "5"
        rowTwoButtons[2].value = "6"
        
        rowThreeButtons[0].value = "7"
        rowThreeButtons[1].value = "8"
        rowThreeButtons[2].value = "9"
        
        rowFourButtons[0].keyType = .unlock
        rowFourButtons[1].value = "0"
        rowFourButtons[2].keyType = .backspace
        
        if #available(iOS 11.0, *) {
            checkBiometrics()
        }
    }
    
    /// Create the required constraints for both portrait and landscape orientation.
    private func createConstraints() {
        keyContainer.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            keyContainerPortraitConstraints.append(contentsOf: [
                keyContainer.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                keyContainer.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
                keyContainer.topAnchor.constraint(equalTo: topAnchor),
                keyContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
                ])
            
            keyContainerLandscapeConstraints.append(contentsOf: [
                keyContainer.topAnchor.constraint(equalTo: topAnchor),
                keyContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                keyContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
                keyContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
                ])
        } else {
            keyContainerPortraitConstraints.append(contentsOf: [
                keyContainer.leftAnchor.constraint(equalTo: leftAnchor),
                keyContainer.rightAnchor.constraint(equalTo: rightAnchor),
                keyContainer.topAnchor.constraint(equalTo: topAnchor),
                keyContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            
            keyContainerLandscapeConstraints.append(contentsOf: [
                keyContainer.topAnchor.constraint(equalTo: topAnchor),
                keyContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
                keyContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
                keyContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
                ])
        }
    }
    
    /// Change the constraints to based on the device orientation.
    private func switchConstraints() {
        switch UIApplication.shared.statusBarOrientation.isPortrait {
        case true:
            NSLayoutConstraint.deactivate(keyContainerLandscapeConstraints)
            NSLayoutConstraint.activate(keyContainerPortraitConstraints)
        case false:
            NSLayoutConstraint.deactivate(keyContainerPortraitConstraints)
            NSLayoutConstraint.activate(keyContainerLandscapeConstraints)
        }
    }
    
}

// MARK: KeyDelegate Methods
extension AuthenticateKeyboard: KeyDelegate {
    
    /// Make sure the pressed key value is displayed in the UITextField that is being edited by the Keyboard.
    func didEnterValue(value: String) {
        if let text = editingTextField.text {
            editingTextField.text = text + value
            editingTextField.sendActions(for: .editingChanged)
        }
    }
    
    /**
        Make sure the authentication process of the biometrics is started, the result is communicated by using the AuthenticationKeyboardDelegate method "didAuthenticate(_ result: UnlockState)"
    */
    func didPressUnlock() {
        editingTextField.resignFirstResponder()
        if #available(iOS 11.0, *) {
            authorizeLocally { [weak self] (state) in
                DispatchQueue.main.async {
                    self?.delegate?.didAuthenticate(state)
                }
            }
        }
    }
    
    /// Make sure the backspace functionality of the UITextField is called when the backspace button of the Keyboard has been pressed.
    func didPressBackspace() {
        editingTextField.deleteBackward()
    }
    
}

// MARK: Unlocking Methods
@available(iOS 11.0, *)
extension AuthenticateKeyboard {
    
    /// Try to authorize the user using biometrics.
    ///
    /// - Parameter completion: The result of the authorization attempt.
    func authorizeLocally(completion: @escaping (UnlockState) -> ()) {
        UnlockingManager.authenticate(unlockReason: String("unlockReason")) { (result, error) in
            if let error = error as NSError? {
                print(error.description)
                completion(.noLocalAuthorize)
            } else {
                completion(result ? .localAuthorizeSuccess : .localAuthorizeFailed)
            }
        }
    }
    
    /// Check if biometrics can be used and if so which type of biometrics is available on the device. Set the Key for the biometrics to the corresponding value.A
    func checkBiometrics() {
        if #available(iOS 11.2, *), !useBiometrics {
            rowFourButtons[0].biometricsType = LABiometryType.none
            return
        } else if !useBiometrics {
            rowFourButtons[0].biometricsType = LABiometryType.LABiometryNone
            return
        }
        
        let biometrics = UnlockingManager.checkBiometrics()
        if #available(iOS 11.2, *) {
            rowFourButtons[0].biometricsType = biometrics.error == nil ? biometrics.biometricsType : .none
        } else {
            rowFourButtons[0].biometricsType = biometrics.error == nil ? biometrics.biometricsType : .LABiometryNone
        }
    }
    
}
