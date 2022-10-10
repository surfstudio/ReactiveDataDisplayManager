Pod::Spec.new do |s|
  s.name = "ReactiveDataDisplayManager"
  s.version = "8.0"
  s.summary = "Library with custom events and reusable adapter for scrollable UI Collections"
  s.homepage = "https://github.com/surfstudio/ReactiveDataDisplayManager"
  s.license = "MIT"
  s.author = { "Alexander Kravchenkov" => "sprintend@gmail.com" }
  s.source = { :git => "https://github.com/surfstudio/ReactiveDataDisplayManager.git", :tag => s.version }

  s.framework = 'UIKit'
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.swift_version = '5.3'

  s.subspec 'Core' do |core|
    core.source_files = 'Source/**/*.swift'
  end

  s.subspec 'Components' do |components|
    components.source_files = 'Components/Sources/**/*.swift'
    components.dependency 'ReactiveDataDisplayManager/Core'
  end
end
