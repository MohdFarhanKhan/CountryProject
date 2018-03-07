//
//  CountryTableViewController.swift
//  TableViewStory
//
//  Created by Mohd Farhan Khan on 3/7/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class CountryTableViewController: UITableViewController {
    
    var privateList = [[String : AnyObject]]()
    var fromIndex = 0
    let batchSize = 20
    let cellId = "CountryCell"
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        self.tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: cellId)
        ApiService.sharedInstance.fetchList(fromIndex: 0, total: batchSize, completion:{ (list: [[String : AnyObject]]) in
            self.fromIndex += self.batchSize
            self.privateList = list
            DispatchQueue.main.sync(execute: { () -> Void in
                self.tableView.reloadData()
            })
       })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "countryDetail" {
             let detailViewController = segue.destination
                as! CountrydetailTableViewController
             detailViewController.countryDict = privateList[selectedIndex]
          }
   }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    // MARK: - Table view data source
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateList.count
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath)
                    as! CountryTableViewCell
       let img = UIImage(named:"loading")
          cell.flagImageView.image = img
       let ctryDict = privateList[indexPath.row] as [String : AnyObject]
       if StoreManager.sharedInstance.isDataExist(dataDict: ctryDict) == true{
            if let image = UIImage(named: "check") {
                cell.checkButton.setImage(image, for: .normal)
            }
       }
       else{
            if let image = UIImage(named: "uncheck") {
                cell.checkButton.setImage(image, for: .normal)
            }
       }
       let flagPngKey = "FlagPng".giveExactKey(dict: ctryDict)
       let flagKey = "Flag".giveExactKey(dict: ctryDict)
       if let flagPng  = ctryDict[flagPngKey] as! String?   {
            let imageInfo = cell.flagImageView.isImageExist(_urlString: flagPng)
            if imageInfo.isImageEixst == false{
                cell.flagImageView.loadImageUsingUrlString(flagPng)
            }
            else{
                cell.flagImageView.image = imageInfo.img
                cell.flagImageView.shapeLayer.removeAllAnimations()
                cell.flagImageView.shapeLayer.removeFromSuperlayer()
                cell.flagImageView.trackLayer.removeFromSuperlayer()
            }
       }
       else if let flagStr = ctryDict[flagKey] as? String {
            let imageInfo = cell.flagImageView.isImageExist(_urlString: flagStr)
            if imageInfo.isImageEixst == false{
                cell.flagImageView.loadImageUsingUrlString(flagStr)
            }
            else{
                cell.flagImageView.image = imageInfo.img
                cell.flagImageView.shapeLayer.removeAllAnimations()
                cell.flagImageView.shapeLayer.removeFromSuperlayer()
                cell.flagImageView.trackLayer.removeFromSuperlayer()
            }
      }
      if let ctryName  = ctryDict["Name"] as! String?   {
           cell.nameLabel.text = ctryName
      }
      cell.onNextTapped = {
           self.selectedIndex = indexPath.row
      }
      cell.onCheckTapped = {
           if StoreManager.sharedInstance.isDataExist(dataDict: ctryDict) == true{
                if let image = UIImage(named: "uncheck") {
                    cell.checkButton.setImage(image, for: .normal)
                }
                StoreManager.sharedInstance.removeDictionary(dataDict: ctryDict)
            }
            else{
                if let image = UIImage(named: "check") {
                    cell.checkButton.setImage(image, for: .normal)
                }
                 StoreManager.sharedInstance.addDictionary(dataDict: ctryDict)
           }
     }
     if indexPath.row == privateList.count - 1 { // last cell
            ApiService.sharedInstance.fetchList(fromIndex: fromIndex, total: batchSize, completion:{ (list: [[String : AnyObject]]) in
                if list.count>0{
                    self.fromIndex += self.batchSize
                    self.privateList += (list as [[String : AnyObject]])
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
     }
       return cell
  }
  
  @IBAction func saveAll(_ sender: Any) {
        StoreManager.sharedInstance.addArray(array: privateList)
        self.tableView.reloadData()
  }
}
