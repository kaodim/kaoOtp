Pod::Spec.new do |s|
  s.name             = 'KaoOtpFlow'
  s.version          = '0.1.0'
  s.summary          = 'OtpFlow view with custom url'
 
  s.description      = <<-DESC
OtpFlow provide complete ui for otp and allow you to inject your own endpoint 
                       DESC
 
  s.homepage         = 'https://auyotoc@bitbucket.org/kaodim/kao-ios-otp.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaodim-ios' => 'tech+ios@kaodim.com' }
  s.source           = { :git => 'https://auyotoc@bitbucket.org/kaodim/kao-ios-otp.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/*'
 
end