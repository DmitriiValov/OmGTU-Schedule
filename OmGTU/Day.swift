//
//  Day.swift
//  OmGTU
//
//  Created by Dmitry Valov on 29.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class Day: NSObject, NSCoding {
    private var title:String!
    private var lessons:Array<String>!
    private var times:Array<String>!

    override init() {
        self.title = ""
        self.lessons = []
        self.times = []
    }

    init(title: String, lessons: Array<String>, times: Array<String>) {
        self.title = title
        self.lessons = lessons
        self.times = times
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(lessons, forKey: "lessons")
        aCoder.encode(times, forKey: "times")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = (aDecoder.decodeObject(forKey: "title") as? String)!
        let lessons = (aDecoder.decodeObject(forKey: "lessons") as? Array<String>)!
        let times = (aDecoder.decodeObject(forKey: "times") as? Array<String>)!
        self.init(title: title, lessons: lessons, times: times)
    }
    
    var dayTitle: String {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    
    var dayLessons: Array<String> {
        get {
            return lessons
        }
        set {
            lessons = newValue
        }
    }
    
    var dayTimes: Array<String> {
        get {
            return times
        }
        set {
            times = newValue
        }
    }
}
