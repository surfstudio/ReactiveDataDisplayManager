use_frameworks!

def utils
  pod 'SurfUtils/ItemsScrollManager', :git => "https://github.com/surfstudio/iOS-Utils.git", :tag => '13.1.0'
end

def diffKit
  pod 'DifferenceKit', '1.3.0'
end

def nuke
  pod 'Nuke', :git => "https://github.com/kean/Nuke.git", :tag => "10.11.2"
end

abstract_target 'Targets' do

  nuke

  target 'ReactiveChat_iOS' do
    platform :ios, '13.0'
    utils
  end

  target 'ReactiveDataDisplayManagerExample_iOS' do
    platform :ios, '11.0'
    utils
    diffKit
    target 'ReactiveDataDisplayManagerExampleUITests'
  end

  target 'ReactiveDataDisplayManagerExample_tvOS' do
    platform :tvos, '13.0'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11'
    end
  end
end
