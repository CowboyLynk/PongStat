//
//  Cup.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/30/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

protocol CupDelegate {
    func didTap(cup: Cup)

    func didLongTap(cup: Cup, longPressGesture: UILongPressGestureRecognizer)
}

// What you really wanted is a view, not a ViewController. Think of a ViewController what controls a full page, whereas each individual box (or image, or button etc) can be though of as a view)
class Cup: UIView {
    // Variables
    // It's best to be as swifty as possible
    var location = (Int(), Int())
    var delegate: CupDelegate?
    
    // Outlets
    @IBOutlet weak var Cup: UIImageView!
    @IBOutlet weak var Shadow: UIImageView!
    @IBOutlet var view: UIView!

    // Functions
    func clear(){
        self.Cup.isHidden = true
    }
    func putBack(){
        self.Cup.isHidden = false
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
        self.delegate?.didLongTap(cup: self, longPressGesture: sender)
    }

    // MARK: The following code is for the initialization
    private func nibSetup() {
        backgroundColor = .clear

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(view)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(longPressGesture)



    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }

}
