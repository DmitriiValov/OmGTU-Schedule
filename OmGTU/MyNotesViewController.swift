//
//  MyNotesViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class MyNotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var captions:Array<String> = []
    var notes:Array<String> = []
    let SectionHeaderHeight: CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let placesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.mySchedule.rawValue) as? NSData else {
            print("'\(UserDefaultsKeys.mySchedule.rawValue)' not found in UserDefaults")
            return
        }
        
        guard let _notes = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [String] else {
            print("Could not unarchive from placesData")
            return
        }
        
        notes = _notes
    }
    
    //MARK: UITableViewDataSource    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func addNote(sender: UIButton!) {
        print("test " + String(sender.tag))
        performSegue(withIdentifier: "addNoteSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LectureTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID") as! LectureTableViewCell
//        cell.nameLabel.text = self.days[indexPath.section].dayLessons[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}
