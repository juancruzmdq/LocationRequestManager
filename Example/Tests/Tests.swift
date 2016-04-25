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
    }
}
