//
//  CalendarViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStrings = Utils.getDates(for: date)
        let dateStringFrom = dateStrings.from
        let dateStringTo = dateStrings.to
        
        UserDefaults.standard.set(dateStringFrom, forKey: UserDefaultsKeys.currDateFrom.rawValue)
        UserDefaults.standard.set(dateStringTo, forKey: UserDefaultsKeys.currDateTo.rawValue)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateDateInfo"), object: nil, userInfo: nil)
        
        self.performSegue(withIdentifier: "selectDateSegue", sender: self)
    }
}
