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
        if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) {
            var weekday = gregorianCalendar.component(.weekday, from: date)
            
            weekday -= 1;
            if weekday == 0 {
                weekday = 7
            }
            
            let year = gregorianCalendar.component(.year, from: date)
            let month = gregorianCalendar.component(.month, from: date)
            let day = gregorianCalendar.component(.day, from: date)
            
            var dateComponentsFrom = DateComponents()
            dateComponentsFrom.year = year
            dateComponentsFrom.month = month
            dateComponentsFrom.day = day - weekday + 1

            var dateComponentsTo = DateComponents()
            dateComponentsTo.year = year
            dateComponentsTo.month = month
            dateComponentsTo.day = day + 7 - weekday

            let dateFrom = gregorianCalendar.date(from: dateComponentsFrom)
            let dateTo = gregorianCalendar.date(from: dateComponentsTo)

            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateStringFrom = formatter.string(from: dateFrom!)
            let dateStringTo = formatter.string(from: dateTo!)

            UserDefaults.standard.set(dateStringFrom, forKey: UserDefaultsKeys.currDateFrom.rawValue)
            UserDefaults.standard.set(dateStringTo, forKey: UserDefaultsKeys.currDateTo.rawValue)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateDateInfo"), object: nil, userInfo: nil)

            self.performSegue(withIdentifier: "selectDateSegue", sender: self)
        }
    }
}
