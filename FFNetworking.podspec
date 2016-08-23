Pod::Spec.new do |s|

  s.name         = "FFNextNetworking"
  s.version      = "1.0"
  s.summary      = ""
  s.description  = ""
  s.ios.deployment_target = '6.0'
  s.platform     = :ios, '6.0'
  s.homepage     = "https://github.com/ixiazer/FFNextNetWorking"
  s.license      = "MIT (example)"
  s.author             = { "徐山" => "kingundertree@163.com" }
  s.source       = { :git => "https://github.com/ixiazer/FFNextNetWorking.git" }


  s.source_files  = 'FFNetwork', 'FFNetwork/*.{h,m}'

  s.subspec 'Assist' do |ss|
      ss.source_files = 'FFNetwork/Assist/*.{h,m}'
  end

  s.subspec 'Category' do |ss|
      ss.source_files = 'FFNetwork/Category/*.{h,m}'
      ss.frameworks = 'Security'
  end

  s.subspec 'Components' do |ss|
      ss.source_files = 'FFNetwork/Components/*.{h,m}'
      ss.frameworks = 'SystemConfiguration'
  end

  s.subspec 'Debug' do |ss|
      ss.source_files = 'FFNetwork/Debug/*.{h,m}'
  end

  s.subspec 'FFNetService' do |ss|
      ss.source_files = 'FFNetwork/FFNetService/*.{h,m}'

      ss.subspec 'ServiceConfig' do |sss|
          sss.source_files = 'FFNetwork/FFNetService/ServiceConfig/*.{h,m}'
      end
  end

  s.subspec 'FFResponse' do |ss|
      ss.source_files = 'FFNetwork/FFResponse/*.{h,m}'
  end  

  s.subspec 'FFSignatureGenerator' do |ss|
      ss.source_files = 'FFNetwork/FFSignatureGenerator/*.{h,m}'
  end  

end
