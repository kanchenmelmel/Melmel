# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Melmel' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Melmel
pod 'FBAnnotationClusteringSwift', :git => 'https://github.com/ribl/FBAnnotationClusteringSwift.git'
pod 'ALThreeCircleSpinner'
pod 'Presentr'
  pod 'Alamofire', '~> 4.0'
  pod 'MelMobile', :git => 'https://github.com/wenyuzhao/MelMobile.git'
  pod 'SwiftMessages'
  pod 'XLForm', '~> 3.0'
  pod 'Firebase'
  pod 'Firebase/Messaging'

  target 'MelmelTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MelmelUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
