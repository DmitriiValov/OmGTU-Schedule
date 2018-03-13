//
//  RequestsEngine.swift
//  OmGTU
//
//  Created by Dmitry Valov on 29.10.17.
//  Copyright © 2017 Dmitry Valov. All rights reserved.
//

import Foundation

class RequestsEngine {
    
    let DAYS_SEPARATOR = "<table class=\"container table table-striped table-bordered\"><thead class=\"schdayhead\"><tr><td colspan=\"2\">"
    let EMPTY_STRING = ""
    let PAIRS_SEPARATOR = "<td class=\"schdaybody\" style=\"width:10%;\">"
    let DAY_HTML_TAGS = "</td><tr></thead>"
    let SCHEDULE_SEPARATOR = "</td><td class=\"schdaybody\" style=\"width:90%;\">"
    let LESSON_HTML_TAGS = "</td></tr></tbody>"
    
    let baseURL = "https://www.omgtu.ru/students/temp/ajax.php?"
    let scheduleURL = "action=get_schedule"
    let groupsURL = "action=get_groups"
    let lectorsURL = "action=get_lecturers&letter="
    
    let faculties: [String]  = ["Гуманитарного образования",
                                "Довузовской подготовки",
                                "Заочного обучения",
                                "Информационных технологий и компьютерных систем",
                                "Машиностроительный",
                                "Нефтехимический",
                                "Отдел аспирантуры и докторантуры",
                                "Радиотехнический",
                                "СПО \"Ориентир\"",
                                "Транспорта, нефти и газа",
                                "Учебно-методическое управление",
                                "Художественно-технологический",
                                "Экономики и сервисных технологий",
                                "Экономики и управления",
                                "Элитного образования и магистратуры",
                                "Энергетический"]

    let courses:[Int] = [1,2,3,4,5,6]
    var notes:Dictionary<String, String> = [:]
    
    static let shared = RequestsEngine()

    private init() {
        loadNotes()
    }
    
    public func getFaculties() -> Array<String> {
        return faculties
    }
    
    public func getCourses() -> Array<Int> {
        return courses
    }
    
    func getLectors(letter: String, completion: @escaping (Array<(Int, String)>?) -> ()) {
        let _letter = letter.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let urlString = baseURL + lectorsURL + _letter!
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                if let data1 = data, let jsonObj = (try? JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.allowFragments)) as? Dictionary<String, AnyObject>, error == nil {
                    
                    let list = jsonObj["list"] as? [[String: String]]
                    
                    var arr:Array<(Int, String)> = []
                    for item in list! {
                        let s:String = item["fio"]!
                        let s1:String = item["lecturerOid"]!
                        
                        arr.append((Int(s1)!, s))
                    }
                    completion(arr)
                }
                else {
                    print("error=\(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }

    func getGroups(faculty: String, course: Int, completion: @escaping (Array<(Int, String)>?) -> ()) {
    
        if let url = URL(string: baseURL + groupsURL) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let postString : String = "filter[type]=g" +
                                      "&filter[faculty]=\(faculty)" +
                                      "&filter[course]=\(course)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                if let data1 = data, let jsonObj = (try? JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.allowFragments)) as? Dictionary<String, AnyObject>, error == nil {

                    let list = jsonObj["list"] as? [[String: String]]
                    
                    var arr:Array<(Int, String)> = []
                    for item in list! {
                        let s:String = item["number"]!
                        let s1:String = item["groupOid"]!
                        
                        arr.append((Int(s1)!, s))
                    }
                    completion(arr)
                }
                else {
                    print("error=\(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }
    
    func getSchedule(faculty: String, course: Int, group: Int, fromDate: String, toDate: String, completion: @escaping (Array<Day>?) -> ()) {
        
        if let url = URL(string: baseURL + scheduleURL) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let postString : String = "filter[type]=g" +
                                      "&filter[faculty]=\(faculty)" +
                                      "&filter[course]=\(course)" +
                                      "&filter[groupOid]=\(group)" +
                                      "&filter[fromDate]=\(fromDate)" +
                                      "&filter[toDate]=\(toDate)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                if let data1 = data, let jsonObj = (try? JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.allowFragments)) as? Dictionary<String, AnyObject>, error == nil {
                    
                    let html = jsonObj["html"] as? String
                    let result = self.parseHtml(html: html!)
                    
                    completion(result)
                }
                else {
                    print("error=\(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }
    
    func getSchedule(lector: Int, fromDate: String, toDate: String, completion: @escaping (Array<Day>?) -> ()) {
        if let url = URL(string: baseURL + scheduleURL) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let postString : String = "filter[type]=l" +
                "&filter[lecturerOid]=\(lector)" +
                "&filter[fromDate]=\(fromDate)" +
                "&filter[toDate]=\(toDate)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                if let data1 = data, let jsonObj = (try? JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.allowFragments)) as? Dictionary<String, AnyObject>, error == nil {
                    
                    let html = jsonObj["html"] as? String
                    let result = self.parseHtml(html: html!)
                    
                    completion(result)
                }
                else {
                    print("error=\(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }
    
    func parseHtml(html: String) -> Array<Day> {
        var _html = html.replacingOccurrences(of: "\r\n", with: "")
        let regex = try! NSRegularExpression(pattern: "[\\s]{2,}", options: [])
        _html = regex.stringByReplacingMatches(in: _html, options: [], range: NSRange(location: 0, length: _html.count), withTemplate: "")
        
        return generateDaysArray(html: _html)
    }
    
    func generateDaysArray(html: String) -> Array<Day> {
        var days:Array<Day> = []
        let daysStrings = html.components(separatedBy: DAYS_SEPARATOR)
        
        if daysStrings.count == 1 {
            let prefix = "<div><div id=\"schedule-list\"><p>"
            let suffix = "</p>"
            var dayString = daysStrings[0]
            
            let startTextRange = dayString.range(of: prefix)
            dayString = String(dayString.suffix(from: (startTextRange?.upperBound)!))
            let endIndexRange = dayString.range(of: suffix)
            dayString = String(dayString.prefix(upTo: (endIndexRange?.lowerBound)!))

            let day:Day = Day()
            day.dayTitle = dayString
            days.append(day)
        }
        else {
            for (i, dayString) in daysStrings.enumerated() {
                if i == 0 {
                    let startTextRange = dayString.range(of: "<div><div id=\"schedule-list\"><div>")
                    var _dayString = String(dayString.suffix(from: (startTextRange?.upperBound)!))
                    let endIndexRange = _dayString.range(of: "</div>")
                    _dayString = String(_dayString.prefix(upTo: (endIndexRange?.lowerBound)!))
                    
                    let day:Day = Day()
                    day.dayTitle = _dayString
                    days.append(day)
                }
                else {
                    let lectures = dayString.components(separatedBy: PAIRS_SEPARATOR)
                    let day:Day = Day()
                    days.append(day)
                    
                    for (j, lectureString) in lectures.enumerated() {
                        if(j == 0) {
                            let  endLectureIndexRange = lectureString.range(of: "</td><tr></thead><tbody>")
                            var _lectureString = String(lectureString.prefix(upTo: (endLectureIndexRange?.lowerBound)!))
                            _lectureString = _lectureString.replacingOccurrences(of: ",", with: ", ")
                            day.dayTitle = _lectureString
                        }
                        else {
                            let pairs = lectureString.components(separatedBy: SCHEDULE_SEPARATOR)
                            var pairTimeAndName:(time:String, name:String) = (time:"", name:"")
                            for pair in pairs {
                                var _pair = ""
                                let  endLectureIndexRange = pair.range(of: "</td></tr></tbody>")
                                if endLectureIndexRange != nil {
                                    _pair = String(pair.prefix(upTo: (endLectureIndexRange?.lowerBound)!))
                                    _pair = _pair.replacingOccurrences(of: "<br/>", with: " ")
                                    pairTimeAndName.name = _pair
                                }
                                else {
                                    _pair = pair.replacingOccurrences(of: "-", with: "- ")
                                    pairTimeAndName.time = _pair
                                }
                            }
                            day.dayLessons.append(pairTimeAndName.name)
                            day.dayTimes.append(pairTimeAndName.time)
                        }
                    }
                }
            }
        }
        return days
    }
    
    func getNotes() -> Dictionary<String, String> {
        return notes
    }
    
    func getNote(forKey key: String) -> String? {
        return notes[key]
    }
    
    func addNote(note: String, forKey key: String) -> String? {
        let result = notes.updateValue(note, forKey: key)
        saveNotes()
        return result
    }
    
    func removeNote(forKey key: String) -> String? {
        let result = notes.removeValue(forKey: key)
        saveNotes()
        return result
    }
    
    func saveNotes() {
        UserDefaults.standard.set(notes, forKey: UserDefaultsKeys.myNotes.rawValue)
    }
    
    func loadNotes() {
        if let _notes:Dictionary<String, String> = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.myNotes.rawValue) as? Dictionary<String, String> {
            notes = _notes
        }
    }
}
