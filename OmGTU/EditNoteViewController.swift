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
    
    var captionText:String = ""
    var noteText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteCaptionLabel.text = captionText
    }
}
