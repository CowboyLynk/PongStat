//
//  Cup.swift
//  PongStatUpdate
//
//  Created by Cowboy Lynk on 6/13/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

protocol CupDelegate {
    func didTap(cup: Cup)
    func didLongPress(cup: Cup, longPressGesture: UILongPressGestureRecognizer)
}

class Cup: UIView {
    // Variables
    var location = (Int(), Int())
    var delegate: CupDelegate?
    
    // Outlets
    @IBOutlet weak var cup: UIImageView!
    @IBOutlet weak var shadow: UIImageView!
    @IBOutlet var view: UIView!
    
    // Actions
    func removeCup(){
        cup.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func didTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTap(cup: self)
    }
    
    func didLongPress(_ sender: UILongPressGestureRecognizer) {
        self.delegate?.didLongPress(cup: self, longPressGesture: sender)
    }
    
    // MARK: The following code is for the initialization
    private func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}
