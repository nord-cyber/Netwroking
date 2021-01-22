# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Networking' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Networking
pod 'Alamofire', '~> 5.2'
pod 'FBSDKCoreKit'  
pod 'FBSDKLoginKit'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'GoogleSignIn'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
end
