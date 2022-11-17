#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_tiphone_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_tiphone_plugin'
  s.version          = '1.0.0'
  s.summary          = 'TiPhone flutter plugin project.'
  s.description      = <<-DESC
TiPhone flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.ios.vendored_frameworks = 'Frameworks/TiPhoneSDK.framework'
  s.vendored_frameworks = 'TiPhoneSDK.framework'
  
  s.ios.vendored_frameworks = 'Frameworks/WebRTC.framework'
  s.vendored_frameworks = 'WebRTC.framework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
