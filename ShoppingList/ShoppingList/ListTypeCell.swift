//
//  ListTypeCell.swift
//  ShoppingList
//
//  Created by Theresa Ganser on 01.02.20.
//  Copyright © 2020 Tamara Zieher. All rights reserved.
//

import UIKit

class ListTypeCell: UITableViewCell {
    @IBOutlet weak var listItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
