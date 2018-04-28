//
//  Group.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class Group: NSObject {
    
    var objectId: String
    var userId: [String]
    var createDate: Date
    var groupName: String
    
    init(objectId: String, userId: [String], createDate: Date, groupName: String) {
        self.objectId = objectId
        self.userId = userId
        self.createDate = createDate
        self.groupName = groupName
    }

}
