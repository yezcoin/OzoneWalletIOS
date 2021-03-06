//
//  ManageWalletTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 10/30/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class ManageWalletTableViewCell: UITableViewCell {
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var walletIsDefaultView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        walletLabel.theme_textColor = O3Theme.primaryColorPicker
        addressLabel.theme_textColor = O3Theme.lightTextColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
    }
}
