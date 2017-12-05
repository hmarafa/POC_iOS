project 'POC_iOS.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios
platform :ios, '9.0'

target 'POC_iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Bean-iOS-OSX-SDK'
  pod 'CorePlot', '~> 2.2'
  pod 'UICircularProgressRing'
  target 'POC_iOSTests' do
    inherit! :search_paths
    pod 'Bean-iOS-OSX-SDK'
      end

  target 'POC_iOSUITests' do
    inherit! :search_paths
    pod 'Bean-iOS-OSX-SDK'# Pods for testing
  end

end
