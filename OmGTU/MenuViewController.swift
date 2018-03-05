//
//  ViewController.swift
//  OmGTU
//
//  Created by Dmitry Valov on 12.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    @IBAction func openSiteAction(_ sender: UIButton) {
        guard let url = URL(string: "http://komnata13.ru/?p=omgtu") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

