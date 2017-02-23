//Copyright (c) 2016 Juan Cruz Ghigliani <juancruzmdq@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation
import CoreLocation

////////////////////////////////////////////////////////////////////////////////
// MARK: Private Extension

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object: object)
        }
    }
}

extension LocationRequest: Equatable {}
public func ==(lhs:LocationRequest,rhs:LocationRequest) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}


////////////////////////////////////////////////////////////////////////////////
// MARK: Types
public typealias AuthorizationBlock = (_ status:CLAuthorizationStatus)-> Void

/**
 *  Class in charge of manage all location request, and handle an internal ios location manager
 
 var locationManager: LocationManager = LocationManager()

 var basicRequest:LocationRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
 ...
 }
 
 var timeoutRequest = LocationRequest{(currentLocation:CLLocation?,error: NSError?)->Void in
 ...
 }
 
 timeoutRequest!.desiredAccuracy = 0
 timeoutRequest!.timeout = 10

 locationManager.performRequest(basicRequest)
 locationManager.performRequest(timeoutRequest)
 
 
 */
public class LocationRequestManager : NSObject,CLLocationManagerDelegate{
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    private let locationManager:CLLocationManager = CLLocationManager()
    private(set) public var requests:[LocationRequest] = []
    private var authorizationBlock:AuthorizationBlock?
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    public override init(){
        super.init()
        locationManager.delegate = self
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    public func addRequest(request:LocationRequest){
        // Already exist the location in the repository
        let exist = self.requests.contains { (currentReq) -> Bool in
            
            if ObjectIdentifier(currentReq) == ObjectIdentifier(request){
                return true
            }else{
                return false
            }
        }
        
        // If not exist add it
        if !exist {
            self.requests.append(request)
        }
    }
    
    public func addRequests(requests:[LocationRequest]){
        for request in requests {
            self.addRequest(request: request)
        }
    }
    
    public func removeRequest(request:LocationRequest){
        self.requests.remove(at: (self.requests as NSArray).index(of: request))
    }

    public func removeRequests(requests:[LocationRequest]){
        self.requests.removeObjectsInArray(array: requests)
    }
    
    public func removeAllRequests(){
        self.requests.removeAll()
    }

    
    /**
     This method add a LocationRequest to the repository, check if the user already accept the location permisions, and start/cancel all request
     
     - parameter request: Intance of LocationRequest
     */
    public func performRequest(request:LocationRequest) {
        self.addRequest(request: request)
        request.status = LocationRequestStatus.Pending
        self.performRequests()
    }

    public func performRequests() {
        
        // set location manager params according to the best presition of all requests
        
        if CLLocationManager.authorizationStatus() == .notDetermined{
            // check which perms should ask according to the plist config
            if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
                self.requestWhenInUseAuthorization(block: { (status) in
                    if status == .authorizedWhenInUse{
                        self.startAllRequests()
                    }else{
                        self.cancelAllRequests()
                    }
                })
            } else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
                self.requestAlwaysAuthorization(block: { (status) in
                    if status == .authorizedAlways{
                        self.startAllRequests()
                    }else{
                        self.cancelAllRequests()
                    }
                })
            }
            
            
        }else if (CLLocationManager.authorizationStatus() == .denied)||(CLLocationManager.authorizationStatus() == .restricted) {
            self.cancelAllRequests()
        }else{
            self.startAllRequests()
        }
    }

    
    public func cancelAllRequests() {
        for request:LocationRequest in self.requests {
            if request.status == LocationRequestStatus.Active {
                request.cancel()
            }
        }
    }
    
    public func startAllRequests() {
        for request:LocationRequest in self.requests {
            if request.status == LocationRequestStatus.Pending {
                request.start()
            }
        }
        self.locationManager.startUpdatingLocation()
    }
    
    /**
     Ask user for location traking while the app is in use, when the user answer, the AuthorizationBlock is executed
     
     - parameter block: blok Instance of AuthorizationBlock
     */
    public func requestWhenInUseAuthorization(block: @escaping AuthorizationBlock) {
        self.authorizationBlock = block
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /**
     Ask user for location traking while the app is in use or in background, when the user answer, the AuthorizationBlock is executed
     
     - parameter block: blok Instance of AuthorizationBlock
     */
    public func requestAlwaysAuthorization(block: @escaping AuthorizationBlock){
        self.authorizationBlock = block
        self.locationManager.requestAlwaysAuthorization()
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: CLLocationManagerDelegate Delegate
    /**
     When authorization status change, report using the AuthorizationBlock
     
     - parameter manager: instance of CLLocationManager
     - parameter status:  CLAuthorizationStatus status
     */
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if let block:AuthorizationBlock = self.authorizationBlock {
            block(status)
        }
    }

    /**
     Report failure to all active location request
     
     - parameter manager: instance of CLLocationManager
     - parameter error:   instance of NSError
     */
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request:LocationRequest in self.requests {
            if request.status == LocationRequestStatus.Active {
                request.update(error: error)
            }
        }
    }
    
    
    /**
     Report location update to all active request, if all request are finished stop the location tracking
     
     - parameter manager:   instance of CLLocationManager
     - parameter locations: array of CLLocation
     */
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get first location element
        let location = locations[0]
        
        // Update status in all active requests
        for request:LocationRequest in self.requests {
            if request.status == LocationRequestStatus.Active {
                request.update(location: location)
            }
        }
        
        // Search if there are any active request
        var shouldStopManager = true
        for request:LocationRequest in self.requests {
            if request.status == LocationRequestStatus.Active {
                shouldStopManager = false
            }
        }

        // If there are no request, stop the location tracker
        if shouldStopManager {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    
}
