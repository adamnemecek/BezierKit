#
#  Be sure to run `pod spec lint BezierKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#

Pod::Spec.new do |s|
  s.name         = "BezierKit"
  s.version      = "0.1.7"
  s.summary      = "comprehensive Bezier curve library written in Swift based on the popular Bezier.js library"
  s.homepage     = "https://github.com/hfutrell/BezierKit"
  s.license      = "MIT"
  s.author       = { "Holmes Futrell" => "holmesfutrell@gmail.com" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.ios.framework  = 'UIKit', 'CoreGraphics'
  s.osx.framework  = 'AppKit'
  #s.tvos.deployment_target = '9.0'
  #s.watchos.deployment_target = '2.0'
  
  s.source       = { :git => "https://github.com/hfutrell/BezierKit.git", :tag => "v#{s.version}"}
  #s.source	  = { :git => "https://github.com/hfutrell/BezierKit.git", :branch => "#{s.version}-release"}

  s.source_files  = "BezierKit/Library"
  #s.exclude_files = "Classes/Exclude"
end
