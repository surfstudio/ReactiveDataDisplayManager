use_frameworks!

def utils
  pod 'SurfUtils/ItemsScrollManager', :git => "https://github.com/surfstudio/iOS-Utils.git", :tag => '11.0.0'
end

def diffKit
  pod 'DifferenceKit', '1.1.5'
end

def nuke
  pod 'Nuke', :git => "https://github.com/kean/Nuke.git", :tag => "10.11.2"
end

abstract_target 'Targets' do

  nuke

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






