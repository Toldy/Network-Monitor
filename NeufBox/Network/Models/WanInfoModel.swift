//
//  WanInfoModel.swift
//  NeufBox
//
//  Created by Julien Colin on 04/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import SWXMLHash

class WanInfoModel {
    var status: String!
    var uptime: Int!
    
    static func parse(xml: XMLIndexer) -> WanInfoModel {
        let wanInfo = WanInfoModel()
        wanInfo.status = xml.element?.attribute(by: "status")?.text ?? ""
        wanInfo.uptime = Int(xml.element?.attribute(by: "uptime")?.text ?? "0")
        return wanInfo
    }
    
    init(status: String = "", uptime: Int = 0) {
        self.status = status
        self.uptime = uptime
    }
}
