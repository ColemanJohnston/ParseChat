//
//  ChatCell.swift
//  ParseChat
//
//  Created by Kristine Laranjo on 2/23/18.
//  Copyright © 2018 Kristine Laranjo. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
