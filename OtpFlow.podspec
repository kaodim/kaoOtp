Pod::Spec.new do |s|
  s.name             = 'OtpFlow'
  s.version          = '0.1.1'
  s.summary          = 'OtpFlow view with custom url'
 
  s.description      = <<-DESC
OtpFlow provide complete ui for otp and allow you to inject your own endpoint 
                       DESC
 
  s.homepage         = 'https://github.com/augustius/OtpFlow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Augustius' => 'cokroeaugustius@gmail.com' }
  s.source           = { :git => 'https://github.com/augustius/OtpFlow.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/*'
 
end