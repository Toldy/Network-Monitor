//
//  APIController.swift
//  NeufBox
//
//  Created by Julien Colin on 03/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import CryptoSwift
import SwiftHTTP
import SWXMLHash

class APIController {
    
    private static let API_URL = "http://neufbox/api/1.0/"
    private static var token: String? = nil
    
    
    // AUTH
    
    static func authenticate(login: String, password: String, onComplete: @escaping ((Error?) -> ())) {
        
        getToken { (token) in
            
            guard let token = token else {
                onComplete(nil) // @TODO: build an Error()
                return
            }
            let usernameHash = generateHash(for: login, with: token)
            let passwordHash = generateHash(for: password, with: token)
            let finalHash = usernameHash + passwordHash
            
            checkToken(token: token, hash: finalHash) { (token) in
                guard let token = token else {
                    onComplete(nil) // @TODO: build an Error()
                    return
                }
                APIController.token = token
                onComplete(nil)
            }
        }
    }
    
    // VOIP
    
    static func voipGetInfo(onComplete: @escaping ((VoipInfoModel, Error?) -> ())) {
        let request = try! HTTP.GET("\(API_URL)?method=voip.getInfo", parameters: ["token": token])
        request.start { response in
            let xml = SWXMLHash.parse(response.data)
            let voipInfo = VoipInfoModel.parse(xml: xml["rsp"]["voip"])
            onComplete(voipInfo, nil)
        }
    }
    
    // WAN
    
    static func wanGetInfo(onComplete: @escaping ((WanInfoModel, Error?) -> ())) {
        let request = try! HTTP.GET("\(API_URL)?method=wan.getInfo", parameters: ["token": token])
        request.start { response in
            let xml = SWXMLHash.parse(response.data)
            let wanInfo = WanInfoModel.parse(xml: xml["rsp"]["wan"])
            onComplete(wanInfo, nil)
        }
    }
    
    // MARK: - Private
    
    private static func getToken(onComplete: @escaping ((String?) -> ())) {
        let request = try! HTTP.GET("\(API_URL)?method=auth.getToken")
        request.start { response in
            let xml = SWXMLHash.parse(response.data)
            if let result = xml["rsp"]["auth"].element?.attribute(by: "token")?.text {
                onComplete(result)
            } else {
                onComplete(nil)
            }
        }
    }
    
    private static func checkToken(token: String, hash: String, onComplete: @escaping ((String?) -> ())) {
        let request = try! HTTP.GET("\(API_URL)?method=auth.checkToken", parameters: ["token": token, "hash": hash])
        request.start { response in
            let xml = SWXMLHash.parse(response.data)
            if let result = xml["rsp"]["auth"].element?.attribute(by: "token")?.text {
                onComplete(result)
            } else {
                onComplete(nil)
            }
        }
    }
    
    // MARK: Misc
    
    // Hashing for auth
    private static func generateHash(for message: String, with token: String) -> String {
        let messageString = message
        let keyString = token
        
        let hash = messageString.sha256().utf8.map({$0})
        let key = keyString.utf8.map({$0})
        
        let result = try! HMAC(key: key, variant: .sha256).authenticate(hash)
        return result.toHexString()
    }
}
