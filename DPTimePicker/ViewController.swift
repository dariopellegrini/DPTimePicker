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
        let alert = UIAlertController(title: "Time selected", message: "\(hour) : \(minute)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func timePickerDidClose(_ timePicker: DPTimePicker) {
        let alert = UIAlertController(title: "Closed", message: "Time picker closed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class ViewController: UIViewController {
    let timePicker: DPTimePicker = DPTimePicker.timePicker()
    let redColor = UIColor(colorLiteralRed: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        timePicker.insertInView(view)
        timePicker.delegate = self
        timePicker.closeButton.setTitleColor(redColor, for: .normal)
        timePicker.closeButton.setTitle("Close", for: .normal)
        timePicker.okButton.setTitleColor(redColor, for: .normal)
        timePicker.okButton.setTitle("OK", for: .normal)
        timePicker.backgroundColor = redColor
        timePicker.numbersColor = UIColor.white
        timePicker.linesColor = UIColor.white
        timePicker.pointsColor = UIColor.white
        timePicker.topGradientColor = redColor
        timePicker.bottomGradientColor = redColor
        timePicker.fadeAnimation = true
        timePicker.springAnimations = true
        timePicker.scrollAnimations = true
        timePicker.areLinesHidden = false
        timePicker.arePointsHidden = false
        timePicker.initialHour = "15"
        timePicker.initialMinute = "12"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show(_ sender: UIButton) {
        timePicker.show(nil)
    }
}



