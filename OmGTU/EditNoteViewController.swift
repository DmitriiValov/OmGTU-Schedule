//
//  EditNoteViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
   
    @IBOutlet weak var noteCaptionLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func okAction(_ sender: UIButton) {
        print("ok")
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        print("cancel")
    }
    
    var captionText:String = ""
    var noteText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteCaptionLabel.text = captionText
        noteTextView.text = noteText
    }
}
