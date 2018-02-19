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
    
    func test1() {
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["faculties_button"]/*[[".buttons[\"ФАКУЛЬТЕТЫ И ГРУППЫ\"]",".buttons[\"faculties_button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables.buttons["Сменить дату"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["22"]/*[[".cells.staticTexts[\"22\"]",".staticTexts[\"22\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let navigationBar = app.navigationBars["Расписание групп"]
        navigationBar.children(matching: .button).element(boundBy: 1).tap()
        navigationBar.buttons["Расписание"].tap()
    }
    
    func test2() {
        
        let app = XCUIApplication()
        app.buttons["ПРЕПОДАВАТЕЛИ"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Сменить дату"].tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["22"]/*[[".cells.staticTexts[\"22\"]",".staticTexts[\"22\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.textFields["Выберите первую букву фамилии"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["А"]/*[[".pickers.pickerWheels[\"А\"]",".pickerWheels[\"А\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.toolbars.buttons["Done"].tap()
        app.navigationBars["Расписание преподавателей"].buttons["Расписание"].tap()
    }
    
    func test3() {
        
        let app = XCUIApplication()
        app.buttons["РАСПИСАНИЕ МОЕЙ ГРУППЫ"].tap()
        app.tables.otherElements["Понедельник, 19.02.2018"].buttons["edit"].tap()
        app.navigationBars["OmGTU.EditNoteView"].buttons["Мое расписание"].tap()
    }
}
