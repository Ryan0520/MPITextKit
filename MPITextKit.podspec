#
# Be sure to run `pod lib lint MPITextKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RMPITextKit'
  s.version          = '0.1.14'
  s.summary          = 'Powerful text framework for iOS to display text based on TextKit.'
  s.homepage         = 'https://github.com/Ryan0520/MPITextKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ryan' => 'coderryan2016@gmail.com' }
  s.source           = { :git => 'https://github.com/Ryan0520/MPITextKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*.{h,m}'
  s.frameworks = 'UIKit', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate'
end
