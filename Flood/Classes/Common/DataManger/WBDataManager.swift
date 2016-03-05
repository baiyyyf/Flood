//
//  WBDataManager.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Alamofire
import Maker

class WBDataManager<T: Maker>: NSObject {
    var requestURL: URLStringConvertible
    var extraParameters: [String: AnyObject]?
    
    init(requestURL: URLStringConvertible, extraParameters params: [String: AnyObject]? = nil) {
        self.requestURL = requestURL
        self.extraParameters = params
    }
    
    func fetchData(sinceId: Int = 0, maxId: Int = 0, completion: Result<T, NSError> -> Void) {
        var parameters: [String: AnyObject] = ["since_id": sinceId, "max_id": maxId, "access_token": "2.002_TFFDfj3PXC2dee38c82bH1azBC", "count": FDConfig.customConfig.refreshCount]
        if let extraParameters = extraParameters {
            parameters.merge(extraParameters)
        }
        let data = try! NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("weibo", ofType: "json")!)!, options: NSJSONReadingOptions())
        let r = Result<T, NSError>.Success(T.objectFromJSON(data))
        completion(r)
//        Alamofire.request(.GET, requestURL, parameters: parameters)
//            .responseJSON {
//                completion($0.result.map(T.objectFromJSON))
//        }
        
    }
}
