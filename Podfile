source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'Food Snap' do
    pod 'Alamofire', '~> 4.4.0'
    pod 'SwiftOverlays'
end

post_install do |installer|
installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
    end
end
end