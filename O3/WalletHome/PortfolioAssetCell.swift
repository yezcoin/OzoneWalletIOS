//
//  PortfolioAssetCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/6/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme

class PortfolioAssetCell: UITableViewCell {
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetAmountLabel: UILabel!
    @IBOutlet weak var assetFiatPriceLabel: UILabel!
    @IBOutlet weak var assetFiatAmountLabel: UILabel!
    @IBOutlet weak var assetPercentChangeLabel: UILabel!
    @IBOutlet weak var assetIcon: UIImageView!

    struct Data {
        var assetName: String
        var amount: Double
        var referenceCurrency: Currency
        var latestPrice: PriceData
        var firstPrice: PriceData
    }

    override func awakeFromNib() {
        let titleLabels = [assetTitleLabel, assetAmountLabel, assetFiatAmountLabel]
        contentView.theme_backgroundColor = O3Theme.cardColorPicker
        theme_backgroundColor = O3Theme.cardColorPicker
        for label in titleLabels {
            label?.theme_textColor = O3Theme.titleColorPicker
        }
        assetFiatPriceLabel.theme_textColor = O3Theme.lightTextColorPicker
        super.awakeFromNib()
    }

    var data: PortfolioAssetCell.Data? {
        didSet {
            guard let assetName = data?.assetName,
                let amount = data?.amount,
                let referenceCurrency = data?.referenceCurrency,
                let latestPrice = data?.latestPrice,
                let firstPrice = data?.firstPrice else {
                    fatalError("undefined data set")
            }
            assetTitleLabel.text = assetName

            let precision = referenceCurrency == .btc ? Precision.btc : Precision.usd
            let referencePrice = referenceCurrency == .btc ? latestPrice.averageBTC : latestPrice.average
            let referenceFirstPrice = referenceCurrency == .btc ? firstPrice.averageBTC : firstPrice.average
            assetAmountLabel.text = amount.string(8, removeTrailing: true)
            if referenceCurrency == .btc {
                assetFiatAmountLabel.text = "₿"+latestPrice.averageBTC.string(Precision.btc, removeTrailing: true)
            } else {
                assetFiatAmountLabel.text = Fiat(amount: Float(referencePrice) * Float(amount)).formattedString()
            }

            //format USD properly
            if referenceCurrency == .btc {
                assetFiatPriceLabel.text = "₿"+referencePrice.string(precision, removeTrailing: referenceCurrency == .btc)
            } else {
                assetFiatPriceLabel.text = Fiat(amount: Float(referencePrice)).formattedString()
            }

            assetPercentChangeLabel.text = String.percentChangeStringShort(latestPrice: latestPrice, previousPrice: firstPrice,
                                                                           referenceCurrency: referenceCurrency)
            
            
            DispatchQueue.main.async {
                if latestPrice.average > firstPrice.average {
                    self.assetPercentChangeLabel.theme_textColor = O3Theme.positiveGainColorPicker
                } else if latestPrice.average < firstPrice.average {
                    self.assetPercentChangeLabel.theme_textColor = O3Theme.negativeLossColorPicker
                } else {
                    self.assetPercentChangeLabel.theme_textColor = O3Theme.lightTextColorPicker
                }
            }

            let logoURL = String(format: "https://cdn.o3.network/img/neo/%@.png", assetName.uppercased())
            assetIcon.kf.setImage(with: URL(string: logoURL))
        }
    }
}
