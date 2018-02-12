//
//  NoteTableViewCell.swift
//  OmGTU
//
//  Created by Dmitry Valov on 30.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
