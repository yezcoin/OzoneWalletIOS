//
//  Money.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/20/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class Money: NSObject {

    var amount: Float = 0
    var locale: String!

    init(amount: Float, locale: String) {
        self.amount = amount
        self.locale = locale
    }
}

class Fiat: Money {
    init(amount: Float) {
        super.init(amount: amount, locale: UserDefaultsManager.referenceFiatCurrency.locale)
    }
}

extension Money {
    func formattedString() -> String {
        if amount.isNaN {
            return ""
        }
        //more than one billion
        if self.amount > 1000000000 {
            var n = Double(self.amount)
            n = Double(n/1000000000)
            let amountNumber = NSNumber(value: n)
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: self.locale)
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: amountNumber as NSNumber) {
                return formattedTipAmount + "B"
            }
        }

        let amountNumber = NSNumber(value: self.amount)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: self.locale)
        formatter.numberStyle = .currency
        if amountNumber.doubleValue <= 0.01  && amountNumber.doubleValue != 0.0 {
            formatter.minimumFractionDigits = 4
        }
        if let formattedTipAmount = formatter.string(from: amountNumber as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }

    func formattedSignedString() -> String {
        if amount.isZero || amount.isNaN {
            return ""
        }
        let amountNumber = NSNumber(value: self.amount)
        let formatter = NumberFormatter()
        formatter.negativeFormat = "- #,##0.00"
        formatter.positiveFormat = "+ #,##0.00"
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        if let formattedTipAmount = formatter.string(from: amountNumber as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }
    
    func formattedStringWithDecimal(decimals: Int) -> String {
        if amount.isZero || amount.isNaN {
            return ""
        }
        let amountNumber = NSNumber(value: amount)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: self.locale)
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = 0
        if let formattedTipAmount = formatter.string(from: amountNumber as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }
}
