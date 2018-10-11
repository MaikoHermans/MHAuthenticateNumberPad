Pod::Spec.new do |s|
  s.platform          = :ios
  s.ios.deployment_target   = '9.3'
  s.name          = "MHAuthenticateNumberPad"
  s.version       = "0.0.3"
  s.summary       = "A keyboard in the shape of Apple's numberpad with the option to use the biometrics iOS provides from the keyboard."
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
