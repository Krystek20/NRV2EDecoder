#
# Be sure to run `pod lib lint NRV2EDecoder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NRV2EDecoder'
  s.version          = '0.1.0'
  s.summary          = 'NRV2EDecoder decodes NRV2E algorithm'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  RV2EDecoder decodes NRV2E algorithm and you can use NRV2EScanner to decode aztec code in Polish vehicle cards.
                       DESC

  s.homepage         = 'https://github.com/Krystek20/NRV2EDecoder'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Krystian Solarz' => 'krystiansolarz@gmail.com' }
  s.source           = { :git => 'https://github.com/Krystek20/NRV2EDecoder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'

  s.source_files = 'NRV2EDecoder/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NRV2EDecoder' => ['NRV2EDecoder/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
