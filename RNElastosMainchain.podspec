require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNElastosMainchain"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  RNElastosMainchain
                   DESC
  s.homepage     = "https://github.com/author/RNElastosMainchain"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNElastosMainchain.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,mm}", 'lib/ios/include/*.h', 'lib/ios/include/nlohmann/*.hpp'
  s.vendored_libraries = "lib/ios/libspvsdk.a"
  s.public_header_files = "ios/**/*.{h,mm}", 'lib/ios/include/*.h', 'lib/ios/include/nlohmann/*.hpp'
  s.requires_arc = true
  s.resource = "ios/Data/*.{txt,json}"

  s.dependency "React"
  #s.dependency "others"
end

