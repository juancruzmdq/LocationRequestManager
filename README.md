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
```

```swift

// performRequest() add and launch the request. We can perform more than one request in parallel . Location manager will be active until satisfy this two request o reach the timeout limit

locationRequestManager.performRequest(self.basicRequest!)

locationRequestManager.performRequest(self.timeoutRequest!)

```

another way to add request to manager

```swift

// We add this 2 request to the manager, and then we decide qhen to perform the requests. Location manager will be active until satisfy this two request o reach the timeout limit

locationRequestManager.addRequest(self.basicRequest!)

locationRequestManager.addRequest(self.timeoutRequest!)

...

locationRequestManager.performRequests()

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
## Request setting

After create a LocationRequest, you can specify a set of parameters that will be used to detect when the location manager can satisfy your needs


The accuracy of the location data. You should assign a value to this property that is appropriate for your usage scenario. For example, if you need the current location only within a kilometer, you should specify kCLLocationAccuracyKilometer and not kCLLocationAccuracyBestForNavigation. Determining a location with greater accuracy requires more time and more power.
```swift
public var desiredAccuracy:CLLocationAccuracy = kCLLocationAccuracyThreeKilometers
```

The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
```swift
public var distanceFilter:CLLocationDistance = kCLDistanceFilterNone;
```

If true, the location manager won't stop return the location, usefull for navigation apps
```swift
public var recurrent:Bool = false
```

Limit of time to return with a valid location. after timeout the callback block will be called, with the status .Timeout
```swift
public var timeout:NSTimeInterval?
```

Callback block that will be called at the end of the location tracking
```swift
public var block:CompleteRequestBlock?
```

Value of the latest location returned by the locationManager
```swift
public var latestLocation:CLLocation?
```

Value of the latest error returned by the locationManager
```swift
public var latestError:NSError?
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
