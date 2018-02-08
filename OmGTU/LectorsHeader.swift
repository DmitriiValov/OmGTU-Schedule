//
//  GroupsHeader.swift
//  OmGTU
//
//  Created by Dmitry Valov on 30.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class LectorsHeader: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var listOfLetters: UITextField!
    @IBOutlet weak var listOfLectors: UITextField!
    @IBOutlet weak var datesLabel: UILabel!

    let lettersTag = 1
    let lectorsTag = 2
    var days:Array<Day> = []
    
    var currentLetter = ""
    var currentLector = ""
    var currentLectorID = -1
    var previousLectorID = -1
    
    var currentDateFrom = ""
    var currentDateTo = ""
    
    var letters:Array<String> = ["А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Э", "Ю", "Я"]
    var lectors:Array<(Int, String)> = []
    let delegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var toolBarLetters = UIToolbar()
    var toolBarLectors = UIToolbar()

    @IBAction func selectDate(_ sender: Any) {}
        
    func initPickers() {
        let pickerLetters = UIPickerView()
        pickerLetters.tag = lettersTag
        pickerLetters.delegate = self
        
        let pickerLectors = UIPickerView()
        pickerLectors.tag = lectorsTag
        pickerLectors.delegate = self
        
        createToolBars()
      
        listOfLetters.inputView = pickerLetters
        listOfLetters.inputAccessoryView = toolBarLetters
        
        listOfLectors.inputView = pickerLectors
        listOfLectors.inputAccessoryView = toolBarLectors
        
        if let _currentDateFrom = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateFrom.rawValue) {
            currentDateFrom = _currentDateFrom
        }
        if let _currentDateTo = UserDefaults.standard.string(forKey: UserDefaultsKeys.currDateTo.rawValue) {
            currentDateTo = _currentDateTo
        }
        datesLabel.text = currentDateFrom + " - " + currentDateTo

        if let _currentLetter = UserDefaults.standard.string(forKey: UserDefaultsKeys.currLetter.rawValue) {
            currentLetter = _currentLetter
        }
        if let _currentLector = UserDefaults.standard.string(forKey: UserDefaultsKeys.currLector.rawValue) {
            currentLector = _currentLector
        }
        currentLectorID = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currLectorID.rawValue)
        
        listOfLetters.text = currentLetter
        listOfLectors.text = currentLector

        if currentLetter != "" {
            RequestsEngine.shared.getLectors(letter: listOfLetters.text!) { arr in
                self.lectors = arr!
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDates(_:)), name: NSNotification.Name(rawValue: "updateDateInfo"), object: nil)
        
        doSearch()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == lettersTag) {
            return letters.count
        }
        else if(pickerView.tag == lectorsTag) {
            return lectors.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == lettersTag) {
            return letters[row]
        }
        else if(pickerView.tag == lectorsTag) {
            return lectors[row].1
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == lettersTag) {
            listOfLetters.text = letters[row]
        }
        else if(pickerView.tag == lectorsTag) {
            previousLectorID = lectors[row].0
            listOfLectors.text = lectors[row].1
        }
    }

    func createToolBars() {
        
        toolBarLetters = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton1.tag = lettersTag
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/3, height: 40))
        label1.text = "Выберите букву"
        let labelButton1 = UIBarButtonItem(customView:label1)
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarLetters.setItems([flexibleSpace1,labelButton1,flexibleSpace1,doneButton1], animated: true)

        toolBarLectors = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton2.tag = lectorsTag
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/3, height: 40))
        label2.text = "Выберите преподавателя"
        let labelButton2 = UIBarButtonItem(customView:label2)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarLectors.setItems([flexibleSpace2,labelButton2,flexibleSpace2,doneButton2], animated: true)
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        listOfLetters.resignFirstResponder()
        listOfLectors.resignFirstResponder()
        
        if(sender.tag == lettersTag) {
            if(currentLetter != listOfLetters.text) {
                currentLetter = listOfLetters.text!
                UserDefaults.standard.set(currentLetter, forKey: UserDefaultsKeys.currLetter.rawValue)
                currentLector = ""
                currentLectorID = -1
                listOfLectors.text = ""
                if listOfLetters.text != "" {
                    RequestsEngine.shared.getLectors(letter: listOfLetters.text!) { arr in
                        self.lectors = arr!
                    }
                }
            }
        }
        else if(sender.tag == lectorsTag) {
            if(currentLector != listOfLectors.text) {
                currentLector = listOfLectors.text!
                currentLectorID = previousLectorID
                UserDefaults.standard.set(currentLector, forKey: UserDefaultsKeys.currLector.rawValue)
                UserDefaults.standard.set(currentLectorID, forKey: UserDefaultsKeys.currLectorID.rawValue)
            }
            doSearch()
        }
    }
    
    func doSearch() {
        if currentLetter != "" &&
           currentLectorID != -1 &&
           currentDateFrom != "" &&
           currentDateTo != "" {
            RequestsEngine.shared.getSchedule(lector: currentLectorID, fromDate: currentDateFrom, toDate: currentDateTo) {
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
