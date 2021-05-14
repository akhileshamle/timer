//
//  BreathingView.swift
//  Reminder
//
//  Created by Akhilesh Amle on 14/05/21.
//

import UIKit

class BreathingView: UIView {
    
    //MARK: setup
    
    let nibName = "BreathingView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
        self.addSubview(view)
        self.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    // MARK: circular view
    var cornerRadius : CGFloat {
        return bounds.height / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.update()
    }
    
    private func update() {
        layer.cornerRadius = self.cornerRadius
    }
    
    // MARK: implementation
    @IBOutlet weak var breathingView: UIView!
    @IBOutlet weak var breathingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMessage : UILabel!
    
    var maxValue : Int = Int.max
    var continueBreathing : Bool = false
    
    var rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    let inhaleString = "I N H A L E"
    let exhaleString = "E X H A L E"
    let holdString = "H O L D"
    
    func start() {
        self.continueBreathing = true
        self.inhale()
    }
    
    private func updateMessage(_ message: String) {
        UIView.animate(withDuration: 0.5) {
            self.lblMessage.alpha = 0
            self.layoutIfNeeded()
        } completion: { (completed) in
            if completed {
                self.lblMessage.text = message
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5) {
                    self.lblMessage.alpha = 1
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func inhale() {
        self.rotate()
        self.updateMessage(self.inhaleString)
        self.layoutIfNeeded()
        self.breathingView.backgroundColor = .systemYellow
        UIView.animate(withDuration: 5) {
            self.breathingViewHeight.constant = self.frame.height
            self.layoutIfNeeded()
        } completion: { (completed) in
            if completed {
                guard self.continueBreathing else { return }
                self.updateMessage(self.holdString)
                self.layoutIfNeeded()
                UIView.animate(withDuration: 5) {
                    self.breathingView.backgroundColor = .systemPink
                    self.layoutIfNeeded()
                } completion: { (completed) in
                    if completed {
                        guard self.continueBreathing else { return }
                        self.exhale()
                    }
                }
            }
        }
    }
    
    private func exhale(_ updateMessage : Bool = true) {
        if updateMessage {
            self.updateMessage(self.exhaleString)
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 5) {
            self.breathingViewHeight.constant = 0
            self.layoutIfNeeded()
        } completion: { (completed) in
            if completed {
                guard self.continueBreathing else { return }
                self.updateMessage(self.holdString)
                self.layoutIfNeeded()
                UIView.animate(withDuration: 5) {
                    self.breathingView.backgroundColor = .systemYellow
                    self.layoutIfNeeded()
                } completion: { (completed) in
                    if completed {
                        guard self.continueBreathing else { return }
                        self.inhale()
                    }
                }
            }
        }
    }
    
    private func rotate() {
        /*
        rotation.fromValue = NSNumber(value: 0)
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.isRemovedOnCompletion = false
        rotation.duration = 10
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
         */
    }
    
    private func stopRotate() {
        // self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func stop() {
        self.stopRotate()
        self.continueBreathing = false
        self.exhale(false)
        self.updateMessage("")
    }
}
