//
//  InfoViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 09/05/21.
//

import UIKit

class InfoViewController: ReminderBaseViewController {
    
    @IBOutlet weak var lblMessage : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = "hh:mm.ss\ntimer."
    }
    
    @IBAction func didSelectClose(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
