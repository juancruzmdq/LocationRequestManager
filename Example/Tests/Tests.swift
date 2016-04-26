// https://github.com/Quick/Quick

import Quick
import Nimble
import LocationRequestManager

class LocationRequestManagerSpec: QuickSpec {
    override func spec() {
        describe("LocationRequestManager") {
            it("Constructor") {
                let lm = LocationRequestManager()
                expect(lm).to(beTruthy())
            }
        }
        describe("LocationRequest") {
            it("Constructor") {

                let lr = LocationRequest({ (currentLocation, error) in
                    print("empty")
                })
                expect(lr).to(beTruthy())
                expect(lr.status == .Pending).to(beTruthy())
            }
        }
        describe("ManageRequests") {
            var locationManager:LocationRequestManager!
            beforeEach{
                locationManager = LocationRequestManager()
            }
            it("Simple Add") {
                let lr1 = LocationRequest(nil)
                let lr2 = LocationRequest(nil)
                
                locationManager.addRequest(lr1)
                locationManager.addRequest(lr2)
                
                expect(locationManager.requests.count).to(equal(2))
                
                // Should avoid duplication of references
                locationManager.addRequest(lr1)
                locationManager.addRequest(lr2)
                
                expect(locationManager.requests.count).to(equal(2))
                
            }
            it("Multiple Add") {
                let lr1 = LocationRequest(nil)
                let lr2 = LocationRequest(nil)
                
                locationManager.addRequests([lr1,lr2])
                
                expect(locationManager.requests.count).to(equal(2))
                
                // Should avoid duplication of references
                locationManager.addRequests([lr1,lr2])
                
                expect(locationManager.requests.count).to(equal(2))
                
            }
            it("Simple Remove") {
                let lr1 = LocationRequest(nil)
                let lr2 = LocationRequest(nil)
                
                locationManager.addRequest(lr1)
                locationManager.addRequest(lr2)
                
                expect(locationManager.requests.count).to(equal(2))
                
                locationManager.removeRequest(lr2)
                
                expect(locationManager.requests.count).to(equal(1))
                
            }
            it("Multiple Remove") {
                let lr1 = LocationRequest(nil)
                let lr2 = LocationRequest(nil)
                let lr3 = LocationRequest(nil)
                
                locationManager.addRequests([lr1,lr2,lr3])
                
                expect(locationManager.requests.count).to(equal(3))
                
                // Should avoid duplication of references
                locationManager.removeRequests([lr1,lr3])
                
                expect(locationManager.requests.count).to(equal(1))
            }
            it("Remove all") {
                let lr1 = LocationRequest(nil)
                let lr2 = LocationRequest(nil)
                let lr3 = LocationRequest(nil)
                
                locationManager.addRequests([lr1,lr2,lr3])
                
                expect(locationManager.requests.count).to(equal(3))
                
                // Should avoid duplication of references
                locationManager.removeAllRequests()
                
                expect(locationManager.requests.count).to(equal(0))
            }

        }
    }
}
