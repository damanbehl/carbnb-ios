# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

use_frameworks!
target 'CarRental' do
  # Comment the next line if you don't want to use dynamic frameworks
  
    pod 'Firebase/Auth'
    pod 'Firebase/Core'
    pod 'Firebase/Firestore'
    pod 'Firebase/Storage'
    pod 'SDWebImage'
    pod 'Cosmos'
    pod 'mailcore2-ios'
  # Pods for CarRental
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
