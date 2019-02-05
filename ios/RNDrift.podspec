
Pod::Spec.new do |s|
  s.name         = "RNDrift"
  s.version      = "1.0.5"
  s.summary      = "RNDrift"
  s.description  = <<-DESC
                  A React Native wrapper for Drift.com platform 🔗
                   DESC
  s.homepage     = "https://github.com/nocturneio/react-native-drift"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "c.delouvencourt@nocturne.app" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/nocturneio/react-native-drift", :tag => "master" }
  s.source_files  = "RNDrift/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  