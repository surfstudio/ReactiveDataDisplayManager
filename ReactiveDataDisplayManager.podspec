Pod::Spec.new do |s|
  s.name = "ReactiveDataDisplayManager"
  s.version = "3.0.2"
  s.summary = "Library with custom events and reusable adapter for UI Collectionclear
  "
  s.homepage = "https://github.com/surfstudio/ReactiveDataDisplayManager"
  s.license = "MIT"
  s.author = { "Alexander Kravchenkov" => "sprintend@gmail.com" }
  s.source = { :git => "https://github.com/surfstudio/ReactiveDataDisplayManager.git", :tag => s.version }

  s.source_files = 'Source/**/*.swift'
  s.framework = 'UIKit'
  s.ios.deployment_target = '9.0'

end
