Pod::Spec.new do |s|

  s.name         = "Meadow"
  s.version      = "0.1"
  s.summary      = "Game engine"
  s.homepage     = "http://scriptorchard.co.uk"
  s.license      = { :type => 'Custom', :file => 'LICENCE' }
  s.author       = { "Zack Brown" => "zack@zackbrown.co.uk" }
  s.requires_arc = true
  s.source       = { :git => "", :tag => s.version.to_s }
  s.default_subspec = 'Core'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |cs|

    cs.source_files = "Meadow/Core/**/*.{h,m,swift}"
    cs.ios.source_files = "Meadow/iOS/**/*.{h,m,swift}"
    cs.osx.source_files = "Meadow/macOS/**/*.{h,m,swift}"

  end

end