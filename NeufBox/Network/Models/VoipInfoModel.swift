//
//  VoipInfoModel.swift
//  NeufBox
//
//  Created by Julien Colin on 04/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import SWXMLHash

struct VoipInfoModel {
    var status: String
    var hookStatus: String
    
    static func parse(xml: XMLIndexer) -> VoipInfoModel {
        var voipInfo = VoipInfoModel(status: "", hookStatus: "")
        voipInfo.status = xml.element?.attribute(by: "status")?.text ?? ""
        voipInfo.hookStatus = xml.element?.attribute(by: "hook_status")?.text ?? ""
        return voipInfo
    }
    
    init(status: String = "", hookStatus: String = "") {
        self.status = status
        self.hookStatus = hookStatus
    }
}
