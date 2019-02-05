require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNDrift"
  s.version      = package["version"]
  s.summary      = "RNDrift"
  s.description  = <<-DESC
                  A simple React Native wrapper for Drift.com platform
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "LICENCE.md" }
  s.author             = { "author" => "c.delouvencourt@nocturne.app" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/nocturneio/react-native-drift", :tag => "master" }
  s.source_files  = "RNDrift/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "Drift" '~> 2.2.7'
end

  