//
//  StartController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/2/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    
    // Outlets
    @IBOutlet weak var sixCup: UIButton!
    @IBOutlet weak var tenCup: UIButton!
    @IBOutlet weak var customCup: UIButton!
    
    // Actions
    @IBAction func requestCustom(_ sender: Any) {
        let alert = UIAlertController(title: "How many cups?", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // Grab the value from the text field
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Num cups: \((textField?.text)!)")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Functions
    func setButtonAppearance(button: UIButton){
        button.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.cornerRadius = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nav Bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Set button styles
        setButtonAppearance(button: sixCup)
        setButtonAppearance(button: tenCup)
        setButtonAppearance(button: customCup)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    

}
