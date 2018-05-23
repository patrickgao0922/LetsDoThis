# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'LetsDoThis' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  def google_pods
    pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
  end

  # Pods for LetsDoThis
  pod 'Alamofire', '~> 4.7'
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'SwiftyJSON'
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'RxAlamofire'
  pod 'PGModelViewController'
  pod 'CryptoSwift'
  pod 'Instabug'
  google_pods
  
def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'Mockingjay'
end

  target 'LetsDoThisTests' do
#    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'LetsDoThisUITests' do
#    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

end

# https://stackoverflow.com/questions/45198857/how-to-build-a-xcode-9-project-with-swift-4-0-using-pods-in-swift-3
swift_32 = ['Swinject','SwinjectStoryboard'] # if these pods are in Swift 3.2
swift4 = [] # if these pods are in Swift 4

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        swift_version = nil
        
        if swift_32.include?(target.name)
            swift_version = '3.2'
        end
        
        if swift4.include?(target.name)
            swift_version = '4.0'
        end
        
        if swift_version
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = swift_version
            end
        end
        
    end
    
end
