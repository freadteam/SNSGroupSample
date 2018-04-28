//
//  User.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var objectId: String
    var userName: String
   // var displayName: String?
 
    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
    
}
