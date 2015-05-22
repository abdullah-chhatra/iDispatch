#
# Be sure to run `pod lib lint MyLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "iDispatch"
  s.version          = "0.1.0"
  s.summary          = "Easy to use wrapper over GCD."
  s.description      = "Easy to use object oriented wrapper over GCD with added functionalities"
  s.homepage         = "https://github.com/abdullah-chhatra/iDispatch.git"
  s.license          = 'MIT'
  s.author           = { "Abdulmunaf Chhatra" => "abdullah.chhatra@gmail.com" }
  s.source           = { :git => "https://github.com/abdullah-chhatra/iDispatch.git", :tag => s.version.to_s }

  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = 'iDispatch/iDispatch/**/*.swift'

end
