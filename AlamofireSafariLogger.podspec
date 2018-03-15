#
# Be sure to run `pod lib lint AlamofireSafariLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlamofireSafariLogger'
  s.version          = '1.0.2'
  s.summary          = 'A logging library under Alamofire library. Allow user to view logging information in Safari Web Inspector.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A logging library under Alamofire library. Allow user to view logging information in Safari Web Inspector.
Please reference to https://github.com/springwong/AlamofireSafariLogger
                       DESC

  s.homepage         = 'https://github.com/springwong/AlamofireSafariLogger'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Spring' => 'rudolphwong2002@gmail.com' }
  s.source           = { :git => 'https://github.com/springwong/AlamofireSafariLogger.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  #s.ios.deployment_target = '8.0'
  s.platforms = { :ios => "8.0" }
  s.swift_version = "3.2"

  s.source_files = 'AlamofireSafariLogger/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AlamofireSafariLogger' => ['AlamofireSafariLogger/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.5'
end
