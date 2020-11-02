source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.2'

target 'Cyton' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'CITA', git: "https://github.com/cryptape/cita-sdk-swift", tag: "v0.25.1"
  pod 'web3.swift.pod', '~> 2.2.0'
  pod 'RealmSwift', '~> 3.20.0'

  pod 'Alamofire'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'EFQRCode'
  pod 'RSKPlaceholderTextView', "~> 4.0.0"
  pod 'BulletinBoard'
  pod 'Toast-Swift'
  pod 'QRCodeReader.swift'

  target 'CytonTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CytonUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end
