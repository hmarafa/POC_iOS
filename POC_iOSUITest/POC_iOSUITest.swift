//
//  POC_iOSUITest.swift
//  POC_iOSUITest
//
//  Created by Hany Arafa on 11/6/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import XCTest

class POC_iOSUITest: XCTestCase {
  var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
         app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()
        app.launchArguments.append("--uitesting")
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    func testGoingThroughOnboarding() {
        app.launch()
        app.launchArguments.append("skipEntryViewController")
        // Make sure we're displaying onboarding
        //XCTAssertTrue(app.isDisplayingOnboarding)
        
        // Swipe left three times to go through the pages
        //app.buttons["Connect"].tap()
        //app.swipeLeft()
     
        
        // Tap the "Done" button
        XCUIApplication().buttons["Connect"].tap()
        XCUIApplication().buttons["Connect"].tap()
               // XCTAssert(app.connecttoBean.exists)
                        //app.buttons["Done"].tap()
        
        // Onboarding should no longer be displayed
        //XCTAssertFalse(app.isDisplayingOnboarding)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
