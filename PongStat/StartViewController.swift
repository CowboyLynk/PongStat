//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    // Variable
    var numInitialCups: Int!
    
    // Outlets
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var nightGraphsButton: UIButton!
    
    // Actions
    @IBAction func playGameButtonPressed(_ sender: Any) {
        presentNumCupsAlert()
    }
    
    // Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PongGameVC {
            destination.numInitialCups = self.numInitialCups
        }
    }
    func presentNumCupsAlert() {
        let alertController = UIAlertController(title: "Number of cups", message: "How many cups are you playing with?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Play", style: .default) { (_) in
            let field = alertController.textFields![0]
            if field.text != "" && Int(field.text!)! > 0 {
                if Int(field.text!)! >= 40 {
                    let alert = UIAlertController(title: "Really?", message: "Yeah, I'm gonna call bullshit on that.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Sorry", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.numInitialCups = Int(field.text!)!
                    self.performSegue(withIdentifier: "playGame", sender: nil)
                }
            } else {
                // user did not fill field
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Number of cups"
            textField.textAlignment = .center
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        
        // Custom button appearances
        playGameButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha: 1.0).cgColor
        playGameButton.layer.shadowOpacity = 1
        playGameButton.layer.shadowRadius = 0
        playGameButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        playGameButton.layer.cornerRadius = 15
        
        nightGraphsButton.layer.shadowColor = UIColor(red:0.5, green:0.5, blue:0.5, alpha: 1.0).cgColor
        nightGraphsButton.layer.shadowOpacity = 1
        nightGraphsButton.layer.shadowRadius = 0
        nightGraphsButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        nightGraphsButton.layer.cornerRadius = 15
        
        // Nav bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

