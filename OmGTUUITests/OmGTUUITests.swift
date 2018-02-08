//
//  OmGTUUITests.swift
//  OmGTUUITests
//
//  Created by Dmitry Valov on 24.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import XCTest

class OmGTUUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        let app = XCUIApplication()
        app.buttons["ФАКУЛЬТЕТЫ И ГРУППЫ"].tap()
        
        let element = app.otherElements.containing(.navigationBar, identifier:"OmGTU.GroupsView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).matching(identifier: "Выберите факультет").element(boundBy: 0).tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Гуманитарного образования"]/*[[".pickers.pickerWheels[\"Гуманитарного образования\"]",".pickerWheels[\"Гуманитарного образования\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let doneButton = app.toolbars.buttons["Done"]
        doneButton.tap()
        element.children(matching: .textField).matching(identifier: "Выберите факультет").element(boundBy: 1).tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["1"]/*[[".pickers.pickerWheels[\"1\"]",".pickerWheels[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        doneButton.tap()
        element.children(matching: .textField).matching(identifier: "Выберите факультет").element(boundBy: 2).tap()
        app.buttons["Выберите дату"].tap()
        
        
//        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["faculties_button"]/*[[".buttons[\"ФАКУЛЬТЕТЫ И ГРУППЫ\"]",".buttons[\"faculties_button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
