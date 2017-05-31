//
//  Cup.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/30/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class Cup: UIViewController {
    // Outlets
    @IBOutlet weak var Cup: UIImageView!
    @IBOutlet weak var Shadow: UIImageView!
    
    // Functions
    func clear(){
        self.Cup.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
