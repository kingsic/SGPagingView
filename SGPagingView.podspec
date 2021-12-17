#
#  Be sure to run `pod spec lint SGPagingView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SGPagingView"
  spec.version      = "2.1.0"
  spec.summary      = "A powerful and easy to use segment view"
  spec.homepage     = "https://github.com/kingsic/SGPagingView"
  spec.license      = "MIT"
  spec.author       = { "kingsic" => "kingsic@126.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = {:git => "https://github.com/kingsic/SGPagingView.git", :tag => spec.version}
  spec.source_files = "Sources/**/*.{swift}"
  spec.requires_arc = true
  spec.swift_versions = "5.0"
end
