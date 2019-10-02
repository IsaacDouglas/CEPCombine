Pod::Spec.new do |s|
  s.name             = 'CEPCombine'
  s.version          = '0.1.0'
  s.summary          = 'Complex Event Processing powered by Combine for Swift.'
  s.description      = 'CEPCombine is a Complex Event Processing tool based on the Combine framework for Swift.'
  s.homepage         = 'https://github.com/IsaacDouglas/CEPCombine'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Isaac Douglas' => 'isaacdouglas2015@gmail.com' }
  s.source           = { :git => 'https://github.com/IsaacDouglas/CEPCombine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.source_files = 'CEPCombine/Classes/**/*'
end
