use_frameworks!

$NukeRepository = "https://github.com/kean/Nuke.git"
$NukeTag = "9.5.1"

def utils
  pod 'SurfUtils/ItemsScrollManager', :git => "https://github.com/surfstudio/iOS-Utils.git", :tag => '11.0.0'
  pod 'DifferenceKit', '1.1.5'
  pod 'Nuke', :git => $NukeRepository, :tag => $NukeTag
end

abstract_target 'Targets' do
  platform :ios, '11.0'
  utils

  target 'ReactiveDataDisplayManagerExample_iOS' do
    target 'ReactiveDataDisplayManagerExampleUITests'
  end

  target 'ReactiveDataDisplayManagerExample_iOS_M1' do
    target 'ReactiveDataDisplayManagerExampleUITests_M1'
  end
end

target 'ReactiveDataDisplayManagerExample_tvOS' do
  platform :ios, '13.0'
  pod 'Nuke', :git => $NukeRepository, :tag => $NukeTag
end
