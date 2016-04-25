# LocationRequestManager

[![CI Status](http://img.shields.io/travis/Juan Cruz Ghigliani/LocationRequestManager.svg?style=flat)](https://travis-ci.org/juancruzmdq/LocationRequestManager.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)
[![License](https://img.shields.io/cocoapods/l/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)
[![Platform](https://img.shields.io/cocoapods/p/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)


This library was created with the intetion of simplify the use of CLLocationManager. LocationRequestManager is a wraper for CLLocationManager which handle a set of LocationRequest. For each request you can specify some parameters like timeout, distance filter, accuracy.


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
let locationRequestManager: LocationRequestManager = LocationRequestManager()
var basicRequest:LocationRequest?
var timeoutRequest:LocationRequest?


self.basicRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
print("\(self.basicRequest!.status) - \(currentLocation) - \(error)")
}

self.timeoutRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
print("\(self.timeoutRequest!.status) - \(currentLocation) - \(error)")
}
self.timeoutRequest!.desiredAccuracy = 1000
self.timeoutRequest!.timeout = 10

locationRequestManager.performRequest(self.basicRequest!)

locationRequestManager.performRequest(self.timeoutRequest!)



```


## Installation

LocationRequestManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LocationRequestManager"
```

## Author

Juan Cruz Ghigliani, juancruzmdq@gmail.com

## License

LocationRequestManager is available under the MIT license. See the LICENSE file for more info.
