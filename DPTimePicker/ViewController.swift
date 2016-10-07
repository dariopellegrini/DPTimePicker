//
//  ViewController.swift
//  DPTimePicker
//
//  Created by Dario Pellegrini on 07/10/16.
//  Copyright © 2016 Dario Pellegrini. All rights reserved.
//

import UIKit

extension ViewController: DPTimePickerDelegate {
    func timePickerDidConfirm(_ hour: String, minute: String, timePicker: DPTimePicker) {
        print()
    }
    
    func timePickerDidClose(_ timePicker: DPTimePicker) {
        print("Nothing")
    }
}

class ViewController: UIViewController {
    let timePicker: DPTimePicker = DPTimePicker.timePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.insertInView(view)
        timePicker.delegate = self
        timePicker.closeButton.titleLabel?.textColor = UIColor.black
        timePicker.closeButton.setTitle("X", for: .normal)
        timePicker.okButton.titleLabel?.textColor = UIColor.red
        timePicker.okButton.setTitle("OK", for: .normal)
        timePicker.backgroundColor = UIColor.red
        timePicker.numbersColor = UIColor.blue
        timePicker.linesColor = UIColor.brown
        timePicker.pointsColor = UIColor.cyan
        timePicker.topGradientColor = UIColor.blue
        timePicker.bottomGradientColor = UIColor.green
        timePicker.fadeAnimation = true
        timePicker.springAnimations = true
        timePicker.areLinesHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show(_ sender: UIButton) {
        timePicker.show(nil)
    }
}



