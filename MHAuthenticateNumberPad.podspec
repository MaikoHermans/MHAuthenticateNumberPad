Pod::Spec.new do |s|
  s.platform          = :ios
  s.ios.deployment_target   = '11.0'
  s.name          = "MHAuthenticateNumberPad"
  s.version       = "0.0.1"
  s.summary       = "A keyboard in the shape of Apple's numberpad with the option to use the biometrics iOS provides from the keyboard."
  s.description  = "Make it possible to trigger the iOS biometrics options from the keyboard when using a numberpad."
  s.requires_arc  = true
  s.swift_version   = '4.0'

  s.license       = { :type => "MIT", :file => "LICENSE" }

  s.author        = { "Maiko Hermans" => "mwmhermans@outlook.com" }

  s.homepage      = "https://github.com/MaikoHermans/MHAuthenticateNumberPad"

  s.source        = { :git => "https://github.com/MaikoHermans/MHAuthenticateNumberPad.git", :tag => "#{s.version}" }
  s.dependency    'IQKeyboardManager', '6.0.4'

  s.source_files  = "MHAuthenticateNumberPad/**/*.{swift,xib}"
  s.resources     = "MHAuthenticateNumberPad/**/*.{xcassets}"
  s.frameworks    = "UIKit", "LocalAuthentication", "Foundation"

end