Pod::Spec.new do |s|
  s.name             = 'navigine_sdk'
  s.version          = '0.0.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = 'A new flutter plugin project.'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'Navigine', "2.4.2"

  s.ios.deployment_target = '13.0'
end
