//
//  LocationRequest.swift
//  Table8
//
//  Created by Juan Cruz Ghigliani on 25/3/16.
//  Copyright © 2016 Table8.com. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation
import CoreLocation

////////////////////////////////////////////////////////////////////////////////
// MARK: Types
typealias CompleteRequestBlock = (currentLocation:CLLocation?,error: NSError?)->Void

enum LocationRequestStatus {
    case Pending
    case Active
    case Timeout
    case Canceled
    case Completed
}

/**
 * Class that define a Location Request to be executed by a LocationManager
 */
class LocationRequest {
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    var status:LocationRequestStatus = .Pending
    var desiredAccuracy:CLLocationAccuracy = kCLLocationAccuracyThreeKilometers
    var distanceFilter:CLLocationDistance = kCLDistanceFilterNone;
    var recurrent:Bool = false
    var timeout:NSTimeInterval?
    var block:CompleteRequestBlock?
    var latestLocation:CLLocation?
    var latestError:NSError?
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties
    private var timer:NSTimer?

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Methods
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    internal init(_ block:CompleteRequestBlock?){
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
        if let timer:NSTimer = self.timer {
            timer.invalidate()
        }
        
        // If there are a currenti timeout defined , start a new timer
        if let interval:NSTimeInterval = self.timeout {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(interval,
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
        if let timer:NSTimer = self.timer {
            timer.invalidate()
        }
        if let blockToCall:CompleteRequestBlock = self.block {
            blockToCall(currentLocation: self.latestLocation,error: self.latestError)
        }

    }
    
    /**
     Time out Listener
     */
    @objc private func onTimeOut(){
        self.timedOut()
    }
    
}