//
//  Key.swift
//  SNSGeldmaatje
//
//  Created by Maiko Hermans on 05/06/2018.
//  Copyright © 2018 dtt. All rights reserved.
//

import UIKit
import LocalAuthentication

/// Delegate for the Key.
protocol KeyDelegate: class {
    /// When a key has been pressed the pressed value will be returned.
    ///
    /// - Parameter value: The value of the key that was pressed.
    func didEnterValue(value: String)
    /// When the key for biometric functions has been pressed this is triggered.
    func didPressUnlock()
    /// When the backspace key has been pressed this is triggered.
    func didPressBackspace()
}

/// 🔑 The Key object which is used to display on the keyboard.
class Key: UIButton {
    
    /// The types of keys the keyboard can hold.
    ///
    /// - number: A key with a number value
    /// - unlock: A key with biometrics capabilities.
    /// - backspace: A key with backspace capabilities.
    /// - empty: A empty key without capabilities other then being a placeholder.
    enum KeyType {
        case number
        case unlock
        case backspace
        case empty
    }
    
    /// The value of the key when it's of the number type.
    var value: String? {
        didSet {
            textLabel.text = value
        }
    }
    
    /// The specified keytype.
    var keyType: KeyType = .number {
        didSet {
            setupKey()
        }
    }
    
    /**
     The biometrics type of the phone, This could either be "Touch ID", "Face ID" or None.
     Even when a phone has biometric capabilities, when the user hasn't set them up the type will be none.
     sets the corresponding image for the key with the unlock type.
    */
    var biometricsType: Any? {
        didSet {
            if #available(iOS 11.0, *) {
                guard let biometricsType = biometricsType as? LABiometryType else { return }
                
                if keyType == .unlock {
                    switch biometricsType {
                    case .faceID:
                        let faceIdImage = UIImage(named: "ic_face_id", in: Bundle(for: self.classForCoder), compatibleWith: nil)
                        setImage(faceIdImage, for: .normal)
                        isUserInteractionEnabled = true
                    case .touchID:
                        let touchIdImage = UIImage(named: "ic_touch_id", in: Bundle(for: self.classForCoder), compatibleWith: nil)
                        setImage(touchIdImage, for: .normal)
                        isUserInteractionEnabled = true
                    case .none:
                        setImage(UIImage(), for: .normal)
                        isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    /// The KeyDelegate.
    weak var delegate: KeyDelegate?
    /// The constraints for the textLabel when the phone is in portrait orientation.
    private var labelPortraitConstraints: [NSLayoutConstraint] = []
    /// The constraints for the textLabel when the phone is in landscape orientation.
    private var labelLandscapeConstraints: [NSLayoutConstraint] = []
    
    /// The class of the base layer inside the button's view.
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    /// Set the image of the key with specified image for specified state where the image will be scaled to fit the button while remaining true to it's aspects (scaleAspectFit).
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        super.setImage(image, for: state)
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    /// Internal utility to retrieve the base layer as a shape layer without casting it everytime.
    private var shape: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    /// The textLabel that will be displayed on the Key.
    private var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    /// Initialization of the Key and all it's aspects.
    private func initView() {
        backgroundColor = .clear
        setTitle(nil, for: .normal)
        
        addSubview(textLabel)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .clear
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        createConstraints()
        textLabel.font = .systemFont(ofSize: 25)
        
        addTarget(self, action: #selector(buttonHighlighted), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(restoreButton), for: .touchDragExit)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupKey()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        changeConstraints()
    }
    
    /// Create the required constraints for both portrait and landscape orientation.
    private func createConstraints() {
        labelPortraitConstraints.append(contentsOf: [
            textLabel.leftAnchor.constraint(equalTo: leftAnchor),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
        labelLandscapeConstraints.append(contentsOf: [
            textLabel.leftAnchor.constraint(equalTo: leftAnchor),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    /// Change the constraints to based on the device orientation.
    private func changeConstraints() {
        switch UIApplication.shared.statusBarOrientation.isPortrait {
        case true:
            NSLayoutConstraint.deactivate(labelLandscapeConstraints)
            NSLayoutConstraint.activate(labelPortraitConstraints)
            imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        case false:
            NSLayoutConstraint.deactivate(labelPortraitConstraints)
            NSLayoutConstraint.activate(labelLandscapeConstraints)
            imageEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    /// Setup the design aspects of the Key.
    private func setupKey() {
        guard keyType == .number else { return }
        
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5, height: 5))
        shape.path = bezierPath.cgPath
        shape.shadowPath = bezierPath.cgPath
        shape.fillColor = UIColor.white.cgColor
        
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
    }
    
}

// MARK: Key Actions
extension Key {
    
    /// Triggered when the key has been highlighted. Will change the alpha to simulate the key being pressed when the key is of type number.
    @objc private func buttonHighlighted() {
        guard keyType == .number else { return }
        
        alpha = 0.4
    }
    
    /// Triggered when the Key has been released. Will trigger the corresponding action for the key.
    @objc private func buttonReleased() {
        switch keyType {
        case .number:
            restoreButton()
            delegate?.didEnterValue(value: value ?? "")
        case .unlock:
            delegate?.didPressUnlock()
        case .backspace:
            delegate?.didPressBackspace()
        case .empty:
            break
        }
    }
    
    /// Restores the button to it's original alpha after the button has been released.
    @objc private func restoreButton() {
        alpha = 1
    }
    
}
