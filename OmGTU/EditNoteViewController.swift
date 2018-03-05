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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func okAction(_ sender: UIButton) {
        _ = RequestsEngine.shared.addNote(note: noteTextView.text, forKey: noteCaptionLabel.text!)
        navigationController?.popViewController(animated: true)
        //todo
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
       _ = RequestsEngine.shared.removeNote(forKey: noteCaptionLabel.text!)
        navigationController?.popViewController(animated: true)
        //todo
    }
    
    var captionText:String = ""
    var noteText:String = ""
    let placeholder:String = "Введите текст заметки..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        noteCaptionLabel.text = captionText
        noteTextView.text = noteText
        
        noteTextView.delegate = self
        if noteText == "" {
            noteTextView.text = placeholder
            noteTextView.textColor = .lightGray
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) 
    {
        if (textView.text == placeholder)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = 10 + keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 10
    }
}
