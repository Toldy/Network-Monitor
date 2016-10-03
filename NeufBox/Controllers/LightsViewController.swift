//
//  LightsViewController.swift
//  NeufBox
//
//  Created by Julien Colin on 03/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import UIKit

class LightView: UIStackView {
    
    @IBOutlet weak var light: UIImageView! {
        didSet {
            setLight(state: false)
        }
    }
    @IBOutlet weak var label: UILabel!
    
    func setLight(state: Bool) {
        if state {
            light.image = UIImage(named: "ic_check")
            light.tintColor = UIColor.green
        } else {
            light.image = UIImage(named: "ic_close")
            light.tintColor = UIColor.red
        }
    }
}

class LightsViewController: UIViewController {
    
    @IBOutlet weak var accessLightView: LightView!
    @IBOutlet weak var trafficLightView: LightView!
    @IBOutlet weak var telephoneLightView: LightView!
    @IBOutlet weak var wifiLightView: LightView!
    
    var voipInfo = VoipInfoModel() {
        didSet {
            telephoneLightView.setLight(state: voipInfo.status == "up")
        }
    }
    var wanInfo = WanInfoModel() {
        didSet {
            accessLightView.setLight(state: wanInfo.status == "up")
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotificationObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotificationObserver()
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LightsViewController.updateVoipInfo),
                                               name: Notifications.updateVoipInfo,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LightsViewController.updateWanInfo),
                                               name: Notifications.updateWanInfo,
                                               object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: Notifications.updateVoipInfo, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.updateWanInfo, object: nil)
    }
    
    // MARK: Network
    
    func updateVoipInfo(notification: Notification) {
        DispatchQueue.main.async {
            self.voipInfo = notification.object as! VoipInfoModel
        }
    }
    
    func updateWanInfo(notification: Notification) {
        DispatchQueue.main.async {
            self.wanInfo = notification.object as! WanInfoModel
        }
    }
}
