//
//  OverviewViewController.swift
//  NeufBox
//
//  Created by Julien Colin on 03/10/16.
//  Copyright © 2016 Julien Colin. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBAction func refreshAction(_ sender: AnyObject?) {
        fetchData()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshAction(nil)
    }
    
    // MARK: Network
    
    func fetchData() {
        APIController.voipGetInfo { (voipInfo, error) in
            NotificationCenter.default.post(name: Notifications.updateVoipInfo, object: voipInfo)
        }
        APIController.wanGetInfo { (wanInfo, error) in
            NotificationCenter.default.post(name: Notifications.updateWanInfo, object: wanInfo)
        }
    }
}
