//
//  MyNotesViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class MyNotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes:Dictionary<String, String> = RequestsEngine.shared.getNotes()
    let SectionHeaderHeight: CGFloat = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notes = RequestsEngine.shared.getNotes()
        tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func addNote(sender: UIButton!) {
        performSegue(withIdentifier: "addNoteSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoteCellID") as! NoteTableViewCell
        let dictKeys  = Array(self.notes.keys)
        cell.noteLabel.text = dictKeys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditNoteSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            let dictKeys  = Array(self.notes.keys)
            let key = dictKeys[indexPath.row]
            let _ = RequestsEngine.shared.removeNote(forKey: key)
            self.notes.removeValue(forKey: key)
            self.tableView.reloadData()
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNoteSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dictKeys  = Array(self.notes.keys)
                let enc = segue.destination as! EditNoteViewController
                let key = dictKeys[indexPath.row]
                enc.captionText = key
                enc.noteText = notes[key]!
            }
        }
    }

    // MARK: - Navigation
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}
