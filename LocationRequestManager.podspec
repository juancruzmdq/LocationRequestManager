
Pod::Spec.new do |s|
  s.name             = "LocationRequestManager"
  s.version          = "0.1.2"
  s.summary          = "Improving CLLocationManager encapsulating the location request in LocationRequest Class."
  s.description      = "This library was created with the intetion of simplify the use of CLLocationManager. LocationRequestManager is a wraper for CLLocationManager which handle a set of LocationRequest. For each request you can specify some parameters like timeout, distance filter, accuracy"

  s.homepage         = "https://github.com/juancruzmdq/LocationRequestManager"
  s.license          = 'MIT'
  s.author           = { "Juan Cruz Ghigliani" => "juancruzmdq@gmail.com" }
  s.source           = { :git => "https://github.com/juancruzmdq/LocationRequestManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/juancruzmdq'

  s.ios.deployment_target = '8.0'
  s.frameworks       = 'Foundation', 'CoreLocation'
  s.source_files     = 'Sources/*.swift'

end
