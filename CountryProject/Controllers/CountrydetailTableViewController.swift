//
//  CountrydetailTableViewController.swift
//  TableViewStory
//
//  Created by Mohd Farhan Khan on 3/7/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit
import MapKit
class CountrydetailTableViewController: UITableViewController {
    
    var countryDict: [String:AnyObject] = [:]
    var keyArray : [String] = ["Area", "Region", "SubRegion", "Alpha3Code","Alpha2Code","NumericCode","NativeName" ,"CurrencySymbol",  "NativeLanguage",  "CurrencyName", "CurrencyCode"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let customImageView = self.view.viewWithTag(999) as! CustomImageView
        if let flagPng = countryDict.valueFor(key: "FlagPng") as! String?{
                let imageInfo = customImageView.isImageExist(_urlString: flagPng)
                if imageInfo.isImageEixst == false{
                    customImageView.loadImageUsingUrlString(flagPng)
                }
                else{
                    customImageView.image = imageInfo.img
                    customImageView.shapeLayer.removeAllAnimations()
                    //self.trackLayer.strokeColor = UIColor.clear.cgColor
                    customImageView.shapeLayer.removeFromSuperlayer()
                    customImageView.trackLayer.removeFromSuperlayer()
                }
       }
       else if let flagStr = countryDict.valueFor(key: "Flag") as? String {
                let imageInfo = customImageView.isImageExist(_urlString: flagStr)
                if imageInfo.isImageEixst == false{
                    customImageView.loadImageUsingUrlString(flagStr)
                }
                else{
                    customImageView.image = imageInfo.img
                    customImageView.shapeLayer.removeAllAnimations()
                    customImageView.shapeLayer.removeFromSuperlayer()
                    customImageView.trackLayer.removeFromSuperlayer()
                }
       }
       let longtudeStr = countryDict.valueFor(key: "Longitude") as! String
       let latitudeStr = countryDict.valueFor(key: "Latitude") as! String
       let longitude = Double(longtudeStr)
       let latitude = Double(latitudeStr)
       let countryName = countryDict.valueFor(key: "Name") as? String
       let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
       let mapView = self.view.viewWithTag(112) as! MKMapView
       mapView.showsUserLocation = true
       let annotation = MKPointAnnotation()
       annotation.coordinate = coordinate
       annotation.title = countryName
       mapView.addAnnotation(annotation)
       mapView.centerCoordinate = coordinate
       self.title = countryName
       
    }
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         let key = keyArray[indexPath.row]
        let  keyValue = countryDict.valueFor(key: key)
        let keyLabel = cell.viewWithTag(100) as! UILabel
        keyLabel.text = key
        let valueLabel = cell.viewWithTag(111) as! UILabel
        if let numberValue = keyValue as? NSNumber{
            valueLabel.text = "\(numberValue)"
        }
        else if let strValue = keyValue as? String{
            valueLabel.text = strValue
        }
        return cell
    }
 }
