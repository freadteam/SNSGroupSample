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
    var user: User
    var createDate: Date
    var groupName: String
    
    init(objectId: String, user: User, createDate: Date, groupName: String) {
        self.objectId = objectId
        self.user = user
        self.createDate = createDate
        self.groupName = groupName
    }

}
