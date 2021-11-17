#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint desk360flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'desk360flutter'
  s.version          = '1.0.0'
  s.summary          = 'Desk360 Flutter SDK'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => "Commercial", :file => '../LICENSE' }
  s.author           = { 'Teknasyon' => 'http://www.teknasyon.com/' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Desk360','~> 1.8'
  s.platform = :ios, '11.0'
  s.static_framework = true 
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
