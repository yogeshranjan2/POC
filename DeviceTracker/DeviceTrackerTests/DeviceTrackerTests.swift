//
//  DeviceTrackerTests.swift
//  DeviceTrackerTests
//
//  Created by Yogesh Ranjan on 11/02/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import XCTest
@testable import DeviceTracker

class DeviceTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeviceInitSuccess() {
        //Test zero rating
        let zeroRatingDevice = Device.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingDevice)
        
        //Test +ve rating
        let positiveRatingDevice = Device.init(name: "Positive", photo: nil, rating: 1)
        XCTAssertNotNil(positiveRatingDevice)
    }
    
    func testDeviceInitFailure() {
        //Test -ve rating
        let negativeRatingDevice = Device.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingDevice)
        
        //Test empty device name
        let emptyDevice = Device.init(name: "", photo: nil, rating: 1)
        XCTAssertNil(emptyDevice)
        
        //Test failure
        let positiveDevice = Device.init(name: "Positive", photo: nil, rating: 1)
        XCTAssertNotNil(positiveDevice)
    }
    
}
