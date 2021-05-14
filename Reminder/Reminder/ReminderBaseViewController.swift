//
//  ReminderBaseViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 09/05/21.
//

import UIKit

class ReminderBaseViewController: UIViewController {
    
    var gradientLayer : CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupgradientBackground()
    }
    
    override func viewWillLayoutSubviews() {
        self.setupgradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupgradientBackground()
    }
    
    private func setupgradientBackground(){
        self.gradientLayer?.removeFromSuperlayer()
        guard let topColor = UIColor(named: "gradientTopColor")?.cgColor else { return }
        guard let bottomColor = UIColor(named: "gradientBottomColor")?.cgColor else { return }
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.colors = [topColor, bottomColor]
        self.gradientLayer?.locations = [0.0, 1.0]
        self.gradientLayer?.frame = self.view.frame
        guard let gradient = self.gradientLayer else { return }
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
