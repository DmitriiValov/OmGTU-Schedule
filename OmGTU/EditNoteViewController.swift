//
//  EditNoteViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 16.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextViewDelegate {
   
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
    let placeholder:String = "Введите текст заметки..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteCaptionLabel.text = captionText
        noteTextView.text = noteText
        
        noteTextView.delegate = self
        if noteText == "" {
            noteTextView.text = placeholder
            noteTextView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) 
    {
        if (textView.text == placeholder)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
