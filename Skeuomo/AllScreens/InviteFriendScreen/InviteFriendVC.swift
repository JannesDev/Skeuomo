//
//  InviteFriendVC.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class InviteFriendVC: UIViewController {

    @IBOutlet weak var imgInviteF: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - ButtonsMethod

    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnShareNow(_ sender: Any) {
    }

}
