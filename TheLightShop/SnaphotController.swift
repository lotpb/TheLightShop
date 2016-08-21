//
//  SnaphotController.swift
//  MoltinSwiftExample
//
//  Created by Peter Balsamo on 6/29/16.
//  Copyright © 2016 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner


class SnaphotController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellsubtitle = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    
    @IBOutlet weak var tableView: UITableView!
    
    private var collections:NSArray = NSArray()
    private var advertisers:NSMutableArray = NSMutableArray()
    private var selectedCollectionDict:NSDictionary?
    private var selectedAdvertisersDict:NSDictionary?
    private let PRODUCTS_LIST_SEGUE_IDENTIFIER = "productsListSegue"
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        titleButton.setTitle("TheLight News", for: UIControlState())
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.center
        titleButton.setTitleColor(UIColor.white, for: UIControlState())
        //titleButton.addTarget(self, action: Selector(), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = titleButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addNewFireflyReference))
        let buttons:NSArray = [searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        self.tableView!.addSubview(refreshControl)
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 100
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.tableView!.tableFooterView = UIView(frame: .zero)
        
        //self.tableView?.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        //self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(-44, 0, 0, 0)
        
        // Show loading UI
        SwiftSpinner.show("Loading Collections", animated:true)
        
        // Get collections, async
        Moltin.sharedInstance().collection.listing(withParameters: nil, success: { (response) -> Void in
  
            SwiftSpinner.hide()
            self.collections = (response?["result"] as? NSArray)!
            self.tableView.reloadData()
            
        }) { (response, error) -> Void in
            SwiftSpinner.hide()
            AlertDialog.showAlert("Error", message: "Couldn't load collections", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
        Moltin.sharedInstance().product.listing(withParameters: ["collection": "1284302377851028385", "limit": NSNumber(value: 8), "offset": 0], success: { (response) -> Void in
            
            SwiftSpinner.hide()
            if let newProducts:NSArray = response?["result"] as? NSArray {
                self.advertisers.addObjects(from: newProducts as [AnyObject])
                
            }
            
            //let responseDictionary = response as NSDictionary
            
            self.tableView.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong!
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load products", viewController: self)
            
            print("Something went wrong...")
            print(error)
        }

    }
    
    func addNewFireflyReference() {
        print("Curse your sudden but inevitable betrayal!")
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Color.headerColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - refresh
    
    func refreshData(_ sender:AnyObject) {
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let result:CGFloat = 220
        if ((indexPath as NSIndexPath).section == 0) {
            
            switch ((indexPath as NSIndexPath).row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if ((indexPath as NSIndexPath).section == 1) {
            let result:CGFloat = 140
            switch ((indexPath as NSIndexPath).row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 2
        }
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableCell
        
        cell.collectionView?.delegate = nil
        cell.collectionView?.dataSource = nil
        cell.collectionView?.backgroundColor = UIColor.white
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            cell.textLabel!.font = Font.cellheaderlabel
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = Font.productTextview
        } else {
            cell.textLabel!.font = Font.cellheaderlabel
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = Font.productTextview
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.textLabel?.text = ""
        
        cell.snaptitleLabel?.numberOfLines = 1
        cell.snaptitleLabel?.text = ""
        cell.snaptitleLabel?.textColor = UIColor.lightGray
        
        cell.snapdetailLabel?.numberOfLines = 3
        cell.snapdetailLabel?.text = ""
        cell.snapdetailLabel?.textColor = UIColor.black
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if ((indexPath as NSIndexPath).section == 0) {
            
            if ((indexPath as NSIndexPath).row == 0) {
                
                cell.textLabel!.text = String(format: "%@", "Top News ")
                cell.selectionStyle = UITableViewCellSelectionStyle.gray
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                return cell
                
            } else if ((indexPath as NSIndexPath).row == 1) {
                
                cell.collectionView?.delegate = self
                cell.collectionView?.dataSource = self
                cell.collectionView?.tag = 0
                
                return cell
                
            } 
            
        } else if ((indexPath as NSIndexPath).section == 1) {
            
            if ((indexPath as NSIndexPath).row == 0) {
                
                cell.textLabel!.text = "Shop by collection"
                
                return cell
                
            } else if ((indexPath as NSIndexPath).row == 1) {
                
                cell.collectionView?.delegate = self
                cell.collectionView?.dataSource = self
                cell.collectionView?.tag = 1
                
                return cell
            }
            
        }
        return cell
    }
    
    
    // MARK: UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView.tag == 0) {
            return CGSize(width: 375, height: 225)
        } else if (collectionView.tag == 1) {
            return CGSize(width: 130, height: 130)
        } 
        return CGSize(width: 120, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (collectionView.tag == 0) {
            return UIEdgeInsetsMake(-20,0,-20,0)
        } else if (collectionView.tag == 1) {
            return UIEdgeInsetsMake(0,0,0,0)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0) // TLBR margin between cells
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        if (collectionView.tag == 0) {
                return advertisers.count
            
        } else if (collectionView.tag == 1) {
                return collections.count
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let myLabel1:UILabel = UILabel(frame: CGRect(x: 0, y: 110, width: cell.bounds.size.width, height: 20))
        myLabel1.backgroundColor = UIColor.white
        myLabel1.textColor = UIColor.black
        myLabel1.textAlignment = NSTextAlignment.center
        myLabel1.clipsToBounds = true
        //myLabel1.font = Font.headtitle
        cell.collectionImage!.backgroundColor = UIColor.white
        if (collectionView.tag == 0) {
            
            cell.loadingSpinner!.isHidden = false
            cell.loadingSpinner!.startAnimating()
            
            let row = (indexPath as NSIndexPath).row
            let advertiserDictionary = advertisers.object(at: row) as? NSDictionary
            cell.setCollectionAdvertiser(advertiserDictionary!)
            
            cell.loadingSpinner!.stopAnimating()
            cell.loadingSpinner!.isHidden = true
            
            return cell
            
        } else if (collectionView.tag == 1) {
            
            cell.loadingSpinner!.isHidden = false
            cell.loadingSpinner!.startAnimating()
            
            let row = (indexPath as NSIndexPath).row
            let collectionDictionary = collections.object(at: row) as? NSDictionary
            cell.setCollectionDictionary(collectionDictionary!)
            
            cell.loadingSpinner!.stopAnimating()
            cell.loadingSpinner!.isHidden = true
            
            return cell
        }
        return cell
    }
    
    
    // MARK: - Segues
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (collectionView.tag == 0) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToCollectionTab()

        } else if (collectionView.tag == 1) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToCollectionTab()
            
            /*
            selectedCollectionDict = collections.objectAtIndex(indexPath.row) as? NSDictionary
            performSegueWithIdentifier("snapshotSegue", sender: self) */
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "snapshotSegue" {
            
            let newViewController = segue.destination as! ProductCollectionController
            newViewController.title = selectedCollectionDict!.value(forKey: "title") as? String
            newViewController.collectionId = selectedCollectionDict!.value(forKeyPath: "id") as? String
        }
    }
    
}

//-----------------------end------------------------------
