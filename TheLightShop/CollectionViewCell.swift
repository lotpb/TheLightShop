//
//  ProductsListTableViewCell.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 16/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    //ProductCollectionController
    @IBOutlet weak var productNameLabel:UILabel?
    @IBOutlet weak var productPriceLabel:UILabel?
    @IBOutlet weak var productImageView:UIImageView?
    
    // SnapshotController
    @IBOutlet weak var collectionLabel:UILabel?
    @IBOutlet weak var collectionImage:UIImageView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    
    func configureWithProduct(_ productDict: NSDictionary) {
       
        productNameLabel?.text = productDict.value(forKey: "title") as? String
        productNameLabel?.font = Font.collectlabel1
        productNameLabel?.textColor = Color.moltinColor
        
        productPriceLabel?.text = productDict.value(forKeyPath: "price.data.formatted.with_tax") as? String
        
        var imageUrl = ""
        
        if let images = productDict.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.value(forKeyPath: "url.https") as! String
            }
        }

        productImageView?.sd_setImage(with: URL(string: imageUrl))
    }
    
    
    func setCollectionAdvertiser(_ dict: NSDictionary) {
        // Set up the cell based on the values of the dictionary that we've been passed
        
        collectionLabel?.text = ""
        //collectionLabel?.font = Font.collectlabel
        
        var imageUrl = ""
        
        if let images = dict.value(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.value(forKeyPath: "url.https") as! String
            }
        }
        
        collectionImage?.sd_setImage(with: URL(string: imageUrl))
        collectionImage!.frame = CGRect(x: 0,y: 0, width: 375, height: 225)

    }
    
    
    func setCollectionDictionary(_ dict: NSDictionary) {
        // Set up the cell based on the values of the dictionary that we've been passed
        
        collectionLabel?.text = "Shop \(dict.value(forKey: "title") as! String)"
        collectionLabel?.font = Font.collectlabel
        collectionLabel?.textColor = Color.appColor
        
        var imageUrl = ""
        
        if let images = dict.value(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.value(forKeyPath: "url.https") as! String
            }
        }
        
        collectionImage?.sd_setImage(with: URL(string: imageUrl))
    }

}
