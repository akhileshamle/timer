//
//  InfoViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 09/05/21.
//

import UIKit

class InfoViewController: ReminderBaseViewController {
    
    @IBOutlet weak var lblMessage : UILabel!

    var shortTime : TimeInterval?
    var longTime : TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let short = self.shortTime, let long = self.longTime {
        lblMessage.text = "Plays a sound after each time interval.\n1. Short interval: \(short) min(s) (only once)\n&\n2. Long interval: every \(long) min(s)"
        }
    }
    
    @IBAction func didSelectClose(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
