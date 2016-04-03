Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name         = "RelayoutKit"
  s.version      = "0.1.2"
  s.summary      = "RelayoutKit."

  s.description  = <<-DESC
                   TableView helper library.
                   DESC

  s.homepage     = "https://github.com/sora0077/RelayoutKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "" => "" }
  s.source       = { :git => "https://github.com/sora0077/RelayoutKit.git", :tag => "#{s.version}" }

  s.source_files  = "RelayoutKit/**/*.{swift}"

end
