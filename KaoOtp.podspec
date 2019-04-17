Pod::Spec.new do |s|
  s.name             = 'KaoOtp'
  s.version          = '0.1.13'
  s.summary          = 'Kaodim custom otp views'
 
  s.description      = <<-DESC
KaoOtpFlow provide complete ui for otp and allow you to inject your own endpoint 
                       DESC
 
  s.homepage         = 'https://github.com/kaodim/kaoOtp.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Augustius' => 'tech+ios@kaodim.com' }
  s.source           = { :git => 'git@github.com:kaodim/kaoOtp.git', :tag => s.version.to_s }

  s.source_files = 'Sources/**/*'
  s.resource_bundles = {
    'OtpCustomPod' => [
        'Sources/**/*.xib'
    ]
  }

  s.dependency 'MaterialTextField', '~> 0.2'
  s.dependency 'KaoDesign', '~> 0.2.1'

  s.pod_target_xcconfig = {
     "SWIFT_VERSION" => "4.0",
  }
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
 
end
