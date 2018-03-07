//
//  StoreManager.swift
//  TableViewStory
//
//  Created by Mohd Farhan Khan on 1/27/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import Foundation
@available(iOS 11.0, *)
class StoreManager: NSObject {
    static let sharedInstance = StoreManager()
    private var  dataArray : NSMutableArray = NSMutableArray()
    
    override init(){
        super.init()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = path.stringByAppendingPathComponent(path: "data.plist")
        if FileManager.default.fileExists(atPath: filePath){
            dataArray = NSMutableArray(contentsOfFile : filePath)!
        }
    }
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
   func saveArray(){
        let filePath = getDocumentsURL().absoluteString.appending("data.plist")
        try? dataArray.write(to: URL(string: filePath)!)
   }
    func isDataExist(dataDict : [String:AnyObject])->Bool{
       var isSaved = false
        for dict in dataArray{
            if  let formattedDict = dict as? [String:AnyObject]{
                if formattedDict.valueFor(key: "Name") as! String == dataDict.valueFor(key: "Name") as! String{
                    isSaved = true
                    break
                }
            }
        }
       return isSaved
    }
    func removeDictionary(dataDict : [String:AnyObject]){
        if isDataExist(dataDict: dataDict) == true{
            dataArray.remove(dataDict)
            saveArray()
        }
    }
    func addDictionary(dataDict : [String:AnyObject]){
        if isDataExist(dataDict: dataDict) == false{
            dataArray.add(dataDict)
            saveArray()
        }
    }
    func addArray(array : [[String:AnyObject]]){
        for dataDict in array{
           addDictionary(dataDict: dataDict)
        }
        
    }
}
