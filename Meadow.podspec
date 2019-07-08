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

  s.ios.deployment_target = '11.3'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '11.3'

  s.subspec 'Core' do |cs|

    cs.source_files = "Meadow/Core/**/*.{h,m,swift}"
    cs.ios.source_files = "Meadow/Platforms/iOS/**/*.{h,m,swift}"
    cs.osx.source_files = "Meadow/Platforms/macOS/**/*.{h,m,swift}"
    cs.tvos.source_files = "Meadow/Platforms/iOS/**/*.{h,m,swift}"

    cs.resource_bundles = {

    	'Meadow' => [

    		"Meadow/Core/**/*.{json,lintel,model,prop,proplist,metal}"
    	]
    }
    
  end

end