//
//  Constants.swift
//  Demo Shop
//
//  Created by Nissi Vieira Miranda on 1/13/16.
//  Copyright © 2016 Nissi Vieira Miranda. All rights reserved.
///Users/peterbalsamo/Desktop/ios/TheLightShop/MoltinSwiftExample/CollectionsViewController.swift

import Foundation

    enum Config {
        // Stripe
        //static let stripeTestPublishableKey = "pk_test_mPxJJ23QTvmtACBDKbkwHwA4"
        // Apple Pay
        //static let appleMerchantId = "YOUR MERCHANT ID"
        
        static let moltinID = "SMWYOlEYTDaOPkVufkm3NIGYsVqHjbHFgQvwFcp1Yr"
    }

    enum Color { //30 65 76
        static let headerColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.0)
        static let moltinColor = UIColor(red: 0.34, green: 0.77, blue: 0.78, alpha: 1.0)
        static let tablebackColor = UIColor.clear
        static let appColor = UIColor.red
    }

    struct Font {
        static let navlabel = UIFont.systemFont(ofSize: 25, weight: UIFontWeightRegular)
        static let cellheaderlabel = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        static let collectlabel = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        static let productTextview = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        static let collectlabel1 = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
    }

