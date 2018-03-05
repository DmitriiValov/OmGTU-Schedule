//
//  GroupsHeader.swift
//  OmGTU
//
//  Created by Dmitry Valov on 30.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class GroupsHeader: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var listOfFaculties: UITextField!
    @IBOutlet weak var listOfCources: UITextField!
    @IBOutlet weak var listOfGroups: UITextField!
    @IBOutlet weak var datesLabel: UILabel!

    let facultiesTag = 1
    let courcesTag = 2
    let groupsTag = 3
    var days:Array<Day> = []
    
    var currentFaculty = ""
    var currentCourse = ""
    var currentGroup = ""
    var currentGroupID = -1
    var previousGroupID = -1
    
    var currentDateFrom = ""
    var currentDateTo = ""
    
    var faculties:Array<String>? = RequestsEngine.shared.getFaculties()
    var courses:Array<String> = ["1", "2", "3", "4", "5", "6"]
    var groups:Array<(Int, String)> = []
    let delegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var toolBarFaculty = UIToolbar()
    var toolBarCourse = UIToolbar()
    var toolBarGroup = UIToolbar()

    @IBAction func selectDate(_ sender: Any) {}
        
    func initPickers() {
        let pickerFaculties = UIPickerView()
        pickerFaculties.tag = facultiesTag
        pickerFaculties.delegate = self
        
        let pickerCources = UIPickerView()
        pickerCources.tag = courcesTag
        pickerCources.delegate = self
        
        let pickerGroups = UIPickerView()
        pickerGroups.tag = groupsTag
        pickerGroups.delegate = self
        
        createToolBars()
      
        listOfFaculties.inputView = pickerFaculties
        listOfFaculties.inputAccessoryView = toolBarFaculty
        
        listOfCources.inputView = pickerCources
        listOfCources.inputAccessoryView = toolBarCourse
        
        listOfGroups.inputView = pickerGroups
        listOfGroups.inputAccessoryView = toolBarGroup
        
        if let _currentDateFrom = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateFrom.rawValue) {
            currentDateFrom = _currentDateFrom
        }
        else {
            currentDateFrom = Utils.getDates(for: Date()).from
            UserDefaults.standard.set(currentDateFrom, forKey: UserDefaultsKeys.currDateFrom.rawValue)
        }
        if let _currentDateTo = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateTo.rawValue) {
            currentDateTo = _currentDateTo
        }
        else {
            currentDateTo = Utils.getDates(for: Date()).to
            UserDefaults.standard.set(currentDateTo, forKey: UserDefaultsKeys.currDateTo.rawValue)
        }
        datesLabel.text = currentDateFrom + " - " + currentDateTo

        if let _currentFaculty = UserDefaults.standard.string(forKey: UserDefaultsKeys.currFaculty.rawValue) {
            currentFaculty = _currentFaculty
        }
        else {
            currentFaculty = RequestsEngine.shared.getFaculties()[0]
        }
        
        if let _currentCourse = UserDefaults.standard.string(forKey: UserDefaultsKeys.currCourse.rawValue) {
            currentCourse = _currentCourse
        }
        else {
            currentCourse = "1"
        }
        
        if let _currentGroup = UserDefaults.standard.string(forKey: UserDefaultsKeys.currGroup.rawValue) {
            currentGroup = _currentGroup
        }
        if let _currentGroup = UserDefaults.standard.string(forKey: UserDefaultsKeys.currGroup.rawValue) {
            currentGroup = _currentGroup
        }
        
        currentGroupID = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currGroupID.rawValue)
        
        listOfFaculties.text = currentFaculty
        listOfCources.text = currentCourse
        listOfGroups.text = currentGroup

        if currentFaculty != "" && currentCourse != "" {
            RequestsEngine.shared.getGroups(faculty: listOfFaculties.text!, course: Int(listOfCources.text!)!) { arr in
                self.groups = arr!
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDates(_:)), name: NSNotification.Name(rawValue: "updateDateInfo"), object: nil)
        
        doSearch()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == facultiesTag) {
            return faculties!.count
        }
        else if(pickerView.tag == courcesTag) {
            return courses.count
        }
        else {
            return groups.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == facultiesTag) {
            return faculties![row]
        }
        else if(pickerView.tag == courcesTag) {
            return courses[row]
        }
        else {
            return groups[row].1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == facultiesTag) {
            listOfFaculties.text = faculties![row]
        }
        else if(pickerView.tag == courcesTag) {
            listOfCources.text = courses[row]
        }
        else {
            previousGroupID = groups[row].0
            listOfGroups.text = groups[row].1
        }
    }

    func createToolBars() {
        
        toolBarFaculty = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton1.tag = facultiesTag
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: 40))
        label1.text = "Выберите факультет"
        let labelButton1 = UIBarButtonItem(customView:label1)
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarFaculty.setItems([flexibleSpace1,labelButton1,flexibleSpace1,doneButton1], animated: true)

        toolBarCourse = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton2.tag = courcesTag
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: 40))
        label2.text = "Выберите курс"
        let labelButton2 = UIBarButtonItem(customView:label2)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarCourse.setItems([flexibleSpace2,labelButton2,flexibleSpace2,doneButton2], animated: true)

        toolBarGroup = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton3.tag = groupsTag
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: 40))
        label3.text = "Выберите группу"
        let labelButton3 = UIBarButtonItem(customView:label3)
        let flexibleSpace3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarGroup.setItems([flexibleSpace3,labelButton3,flexibleSpace3,doneButton3], animated: true)
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        listOfFaculties.resignFirstResponder()
        listOfCources.resignFirstResponder()
        listOfGroups.resignFirstResponder()
        
        if(sender.tag == facultiesTag) {
            if(currentFaculty != listOfFaculties.text) {
                currentFaculty = listOfFaculties.text!
                UserDefaults.standard.set(currentFaculty, forKey: UserDefaultsKeys.currFaculty.rawValue)
                currentGroup = ""
                currentGroupID = -1
                listOfGroups.text = ""
                if listOfFaculties.text != "" && listOfCources.text != "" {
                    RequestsEngine.shared.getGroups(faculty: listOfFaculties.text!, course: Int(listOfCources.text!)!) { arr in
                        self.groups = arr!
                    }
                }
            }
        }
        else if(sender.tag == courcesTag) {
            if(currentCourse != listOfCources.text) {
                currentCourse = listOfCources.text!
                UserDefaults.standard.set(currentCourse, forKey: UserDefaultsKeys.currCourse.rawValue)
                currentGroup = ""
                currentGroupID = -1
                listOfGroups.text = ""
                
                if listOfFaculties.text != "" && listOfCources.text != "" {
                    RequestsEngine.shared.getGroups(faculty: listOfFaculties.text!, course: Int(listOfCources.text!)!) { arr in
                        self.groups = arr!
                    }
                }
            }
        }
        else if(sender.tag == groupsTag) {
            if(currentGroup != listOfGroups.text) {
                currentGroup = listOfGroups.text!
                currentGroupID = previousGroupID
                UserDefaults.standard.set(currentGroup, forKey: UserDefaultsKeys.currGroup.rawValue)
                UserDefaults.standard.set(currentGroupID, forKey: UserDefaultsKeys.currGroupID.rawValue)
            }
            doSearch()
        }
    }
    
    func doSearch() {
        if currentFaculty != "" &&
           currentCourse != "" &&
           currentGroupID != -1 &&
           currentDateFrom != "" &&
           currentDateTo != "" {
            RequestsEngine.shared.getSchedule(faculty: currentFaculty, course: Int(currentCourse)!, group: currentGroupID, fromDate: currentDateFrom, toDate: currentDateTo) {
                _days in
                self.days = _days!
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTableInfo"), object: nil, userInfo: nil)
                }
            }
        }
    }
    
    @objc func updateDates (_ notification: NSNotification) {
        if let _currentDateFrom = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateFrom.rawValue) {
            currentDateFrom = _currentDateFrom
        }
        if let _currentDateTo = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateTo.rawValue) {
            currentDateTo = _currentDateTo
        }
        datesLabel.text = currentDateFrom + " - " + currentDateTo
        doSearch()
    }
}
