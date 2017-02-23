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
// MARK: Types
public typealias CompleteRequestBlock = (_ currentLocation:CLLocation?, _ error: NSError?)->Void

public enum LocationRequestStatus {
    case Pending
    case Active
    case Timeout
    case Canceled
    case Completed
}

/**
 * Class that define a Location Request to be executed by a LocationManager
 */
public class LocationRequest {
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    public var status:LocationRequestStatus = .Pending
    public var desiredAccuracy:CLLocationAccuracy = kCLLocationAccuracyThreeKilometers
    public var distanceFilter:CLLocationDistance = kCLDistanceFilterNone;
    public var recurrent:Bool = false
    public var timeout:TimeInterval?
    public var block:CompleteRequestBlock?
    public var latestLocation:CLLocation?
    public var latestError:NSError?
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties
    private var timer:Timer?

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Methods
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    public  init(_ block:CompleteRequestBlock?){
        self.block = block
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    /**
     Change request status to .Start, if the request have a timeout, initialize the timer
     */
    func start(){
        // Change request status to .Active
        self.status = .Active
        
        // If there are an old timer active, invalidate it
        if let timer:Timer = self.timer {
            timer.invalidate()
        }
        
        // If there are a currenti timeout defined , start a new timer
        if let interval:TimeInterval = self.timeout {
            self.timer = Timer.scheduledTimer(timeInterval: interval,
                                                                target: self,
                                                                selector: #selector(LocationRequest.onTimeOut),
                                                                userInfo: nil,
                                                                repeats: false)
        }
    }
    
    /**
     Update current request with an error status, and finish the request
     
     - parameter error: instance of NSError
     
     - returns: true if the request was updated
     */
    func update(error: NSError) -> Bool {
        self.latestError = error
        self.complete()
        return true
    }

    /**
     Update current request with a CLLocation, if the accuracy is the one defined by the user, and is not a reccurrent request, finish it
     
     - parameter location: instance of CLLocation
     
     - returns: true if the request was updated
     */
    func update(location:CLLocation) -> Bool {
        // Clean latest location and error
        self.latestLocation = location
        self.latestError = nil
        
        if !recurrent {
            //horizontalAccuracy represent accuracy in meters, lower value reprecent lower level of error
            if location.horizontalAccuracy <= self.desiredAccuracy {
                self.complete()
            }
        }
        return true
    }

    /**
     Change request status to .Completed and stop request
     */
    func complete(){
        self.status = .Completed
        self.stopAndReport()
    }

    /**
     Change request status to .Canceled and stop request
     */
    func cancel(){
        self.status = .Canceled
        self.stopAndReport()
    }
    
    /**
     Change request status to .Timeout and stop request
     */
    func timedOut(){
        self.status = .Timeout
        self.stopAndReport()
    }
    
    /**
     Stop current request timer, and call block that report t the user
     */
    func stopAndReport()  {
        if let timer:Timer = self.timer {
            timer.invalidate()
        }
        if let blockToCall:CompleteRequestBlock = self.block {
            blockToCall(self.latestLocation,self.latestError)
        }

    }
    
    /**
     Time out Listener
     */
    @objc private func onTimeOut(){
        self.timedOut()
    }
    
}
