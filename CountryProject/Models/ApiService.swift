//
//  ApiService.swift
//  TableViewStory
//
//  Created by Mohd Farhan Khan on 3/7/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    private var comp : ([[String : AnyObject]]) -> () = {_ in }
    static let sharedInstance = ApiService()
    private var countryArray :  [[String : AnyObject]]  = []
    private var from : Int = -1
    private var count : Int = 0
    private let baseUrl = "http://countryapi.gear.host/v1/Country/getCountries"
    
    override init(){
       super.init()
       fetchListForUrlString(baseUrl)
    }
    func fetchList(fromIndex : Int , total: Int, completion: @escaping ([[String : AnyObject]]) -> ()) {
       if countryArray.count>0{
            if fromIndex>=countryArray.count{
                completion([])
                return
            }
            var items :  [[String : AnyObject ]] = []
            let totalIndex = fromIndex+total
            var howMany = total
            if totalIndex>countryArray.count{
               howMany = countryArray.count-fromIndex
            }
            for i in fromIndex...(fromIndex+howMany-1){
              
              items.append(countryArray[i])
            }
            from = -1
            count = 0
            completion(items)
      }
      else{
         from = fromIndex
         count = total
         comp = completion
      }
       
    }
    private func sendElements(){
        var items :  [[String : AnyObject ]] = []
        let totalIndex = from+count
        var howMany = count
        if totalIndex>countryArray.count{
            howMany = countryArray.count-from
        }
        for i in from...howMany-1{
            items.append(countryArray[i])
        }
        from = -1
        count = 0
        comp(items)
   }
   private func fetchListForUrlString(_ urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
           if error != nil {
                print(error as Any?)
                return
            }
           do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                    self.countryArray = jsonDictionaries["Response"] as! [[String : AnyObject]]
                    if self.from > -1{
                       self.sendElements()
                    }
                }
           } catch let jsonError {
                print(jsonError)
            }
       }) .resume()
   }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    func isImageExist(_urlString: String)->(isImageEixst : Bool, img : UIImage){
        var thisImage : UIImage = UIImage()
        var isExist = false
        if let imageFromCache = imageCache.object(forKey: _urlString as AnyObject) as? UIImage {
         thisImage = imageFromCache
         isExist = true
       }
        return (isExist,thisImage)
    }
    func loadImageUsingUrlString(_ urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
           DispatchQueue.main.async(execute: {
                 self.image = imageFromCache
           })
            return
        }
        let center = self.center
        self.image = nil
        let circularPath = UIBezierPath(arcCenter: center, radius: (self.frame.size.height)/2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.repeatCount = .infinity
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString , let _ = imageToCache{
                    self.shapeLayer.removeAllAnimations()
                    self.shapeLayer.removeFromSuperlayer()
                    self.trackLayer.removeFromSuperlayer()
                    self.image = imageToCache
                    self.startAnimating()
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                }
           })
      }).resume()
    }
}

