Pod::Spec.new do |s|
  s.name             = 'KaoOtpFlow'
  s.version          = '0.1.4'
  s.summary          = 'Kaodim custom otp views'
 
  s.description      = <<-DESC
KaoOtpFlow provide complete ui for otp and allow you to inject your own endpoint 
                       DESC
 
  s.homepage         = 'https://github.com/augustius/KaoOtpFlow.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Augustius' => 'tech+ios@kaodim.com' }
  s.source           = { :git => 'https://auyotoc@bitbucket.org/kaodim/kao-ios-otp.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Source/*'
 
end