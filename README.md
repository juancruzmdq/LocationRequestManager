# LocationRequestManager

[![CI Status](http://img.shields.io/travis/juancruzmdq/LocationRequestManager.svg?style=flat)](https://travis-ci.org/juancruzmdq/LocationRequestManager.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)
[![License](https://img.shields.io/cocoapods/l/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)
[![Platform](https://img.shields.io/cocoapods/p/LocationRequestManager.svg?style=flat)](http://cocoapods.org/pods/LocationRequestManager)


This library was created with the intetion of simplify the use of CLLocationManager. LocationRequestManager is a wraper for CLLocationManager which handle a set of LocationRequest. For each request you can specify some parameters like timeout, distance filter, accuracy.


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You should create an instance of LocationRequestManager, this class will be in charge of initialice a locationManager, ask for Authorization to the user, and handle all user location request.

When you need the current location, you should create a new LocationRequest, and pass this request to the locationManager. The location manager will be listening your location until be able to satisfy your request

You can send more that one simultaneous request, location manager will be active, until satisfy all requests

```swift
let locationRequestManager: LocationRequestManager = LocationRequestManager()

// we create to request
var basicRequest:LocationRequest?
var timeoutRequest:LocationRequest?


self.basicRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
print("\(self.basicRequest!.status) - \(currentLocation) - \(error)")
}

self.timeoutRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
print("\(self.timeoutRequest!.status) - \(currentLocation) - \(error)")
}
self.timeoutRequest!.desiredAccuracy = kCLLocationAccuracyBest // CLLocationAccuracy
self.timeoutRequest!.timeout = 10

// We launch, this two request. Location manager will be active until satisfy this two request o reach the timeout limit

locationRequestManager.performRequest(self.basicRequest!)

locationRequestManager.performRequest(self.timeoutRequest!)


```

## Request Location Authorization

When you call performRequest() the library will check the permision's status, and if necessary will call  requestAlwaysAuthorization or requestWhenInUseAuthorization depending your plist settings (kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse)

But you can also call the request auth flow when you need, for example:

```swift
let locationRequestManager: LocationRequestManager = LocationRequestManager()

locationRequestManager.requestAlwaysAuthorization { (status:CLAuthorizationStatus) in
    print("Auth Status: \(status)")
}

```
or

```swift
let locationRequestManager: LocationRequestManager = LocationRequestManager()

locationRequestManager.requestWhenInUseAuthorization { (status:CLAuthorizationStatus) in
    print("Auth Status: \(status)")
}

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
