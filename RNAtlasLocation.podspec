#
# Be sure to run `pod lib lint RNAtlasLocation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RNAtlasLocation'
  s.version          = '0.1.0'
  s.summary          = 'A React Native cross-platform location library built with fitness apps in mind'
  s.homepage         = 'https://github.com/atlasrun/react-native-atlas-location'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'seo' => 'so.townsend@gmail.com' }
  s.source           = { :git => 'https://github.com/seo/RNAtlasLocation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ios/RNAtlasLocation/Classes/**/*'
  s.dependency "React"
  
  # s.resource_bundles = {
  #   'RNAtlasLocation' => ['RNAtlasLocation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
