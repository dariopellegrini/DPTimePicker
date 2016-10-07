//
//  DPTimePicker.swift
//  S4winApp
//
//  Created by Dario Pellegrini on 15/09/16.
//

import UIKit

public protocol DPTimePickerDelegate {
    func timePickerDidConfirm(_ hour: String, minute: String, timePicker: DPTimePicker)
    func timePickerDidClose(_ timePicker: DPTimePicker)
}

extension DPTimePicker: UICollectionViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let factor: CGFloat = scrollView.contentOffset.y / 45
        let newContentOffset: CGFloat = round(factor) * 45
        scrollView.setContentOffset(CGPoint(x: 0, y: newContentOffset), animated: true)
        
        if scrollView.tag == 101 {
            if let cell = hoursCollectionView.cellForItem(at: IndexPath(row: Int(round(factor)), section: 0)) as? DPTimeCollectionViewCell {
                selectedHour = cell.textLabel.text ?? "00"
            }
        } else {
            if let cell = minutesCollectionView.cellForItem(at: IndexPath(row: Int(round(factor)), section: 0)) as? DPTimeCollectionViewCell {
                selectedMinute = cell.textLabel.text ?? "00"
            }
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let factor: CGFloat = scrollView.contentOffset.y / 45
        let newContentOffset: CGFloat = round(factor) * 45
        scrollView.setContentOffset(CGPoint(x: 0, y: newContentOffset), animated: true)
        
        if scrollView.tag == 101 {
            if let cell = hoursCollectionView.cellForItem(at: IndexPath(row: Int(round(factor)), section: 0)) as? DPTimeCollectionViewCell {
                selectedHour = cell.textLabel.text ?? "00"
            }
        } else {
            if let cell = minutesCollectionView.cellForItem(at: IndexPath(row: Int(round(factor)), section: 0)) as? DPTimeCollectionViewCell {
                selectedMinute = cell.textLabel.text ?? "00"
            }
        }

    }
}

extension DPTimePicker: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 101 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DPTimeCollectionViewCell", for: indexPath) as! DPTimeCollectionViewCell
        cell.textLabel.textColor = numbersColor
        if collectionView.tag == 101 {
            cell.textLabel.text = hours[(indexPath as NSIndexPath).row]
        } else {
            cell.textLabel.text = minutes[(indexPath as NSIndexPath).row]
        }
        return cell
    }
}

open class DPTimePicker: UIView {
    var hours: [String] = []
    var minutes: [String] = []
    var selectedHour: String = "00"
    var selectedMinute: String = "00"
    var initialHour: String = "00"
    var initialMinute: String = "00"
    
    open var delegate: DPTimePickerDelegate?
    
    open var numbersColor: UIColor = UIColor.white
    open var linesColor: UIColor = UIColor.white
    open var pointsColor: UIColor = UIColor.white
    open var topGradientColor = UIColor.orange
    open var bottomGradientColor = UIColor.orange
    
    open var areLinesHidden = false
    open var arePointsHidden = false
    
    open var fadeAnimation = true
    open var springAnimations = true
    open var scrollAnimations = true

    @IBOutlet weak var centralLabel: UILabel!
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    @IBOutlet weak var minutesCollectionView: UICollectionView!
    @IBOutlet weak var hoursTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var minutesLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak open var okButton: UIButton!
    @IBOutlet weak open var closeButton: UIButton!
    @IBOutlet weak var topGradientView: EZYGradientView!
    @IBOutlet weak var bottomGradientView: EZYGradientView!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel: UILabel!
    let widthHeight: CGFloat = 45
    
    override open func awakeFromNib() {
        okButton.layer.cornerRadius = buttonHeightConstraint.constant / 2
        closeButton.layer.cornerRadius = buttonHeightConstraint.constant / 2
    }
    
    open static func timePicker() -> DPTimePicker {
        let bundle = Bundle(for: DPTimePicker.self)
        let nibViews = bundle.loadNibNamed("DPTimePicker", owner: nil, options: nil)
        let timePicker = nibViews?.first as! DPTimePicker
        timePicker.hoursCollectionView.dataSource = timePicker
        timePicker.hoursCollectionView.backgroundColor = UIColor.clear
        timePicker.hoursCollectionView.delegate = timePicker
        
        timePicker.minutesCollectionView.dataSource = timePicker
        timePicker.minutesCollectionView.backgroundColor = UIColor.clear
        timePicker.minutesCollectionView.delegate = timePicker
        
        timePicker.hoursCollectionView.register(UINib(nibName: "DPTimeCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "DPTimeCollectionViewCell")
        timePicker.minutesCollectionView.register(UINib(nibName: "DPTimeCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "DPTimeCollectionViewCell")
        
        return timePicker
    }
    
    open func insertInView(_ view: UIView) {
        self.alpha = 0.0
        for i in 0...23 {
            hours.append(String(format: "%02d", i))
        }
        
        for i in 0...59 {
            minutes.append(String(format: "%02d", i))
        }
        
        self.frame = view.frame
        view.addSubview(self)
        
        let views = ["timePicker":self];
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[timePicker]-0-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[timePicker]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        view.addConstraints(verticalConstraints)
        
        let insets: CGFloat = (view.frame.size.height / 2) - (widthHeight / 1.5)
        (hoursCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: insets, left: 0, bottom: insets, right: 0)
        (minutesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsets(top: insets, left: 0, bottom: insets, right: 0)
        
        hoursCollectionView.reloadData()
        minutesCollectionView.reloadData()
    }
    
    func configureInitialComponents() {
        centralLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        hoursTrailingConstraint.constant = UIScreen.main.bounds.size.width / 2
        minutesLeadingConstraint.constant = UIScreen.main.bounds.size.width / 2
        topLineView.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
        bottomLineView.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
        okButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        closeButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        layoutIfNeeded()
    }
    
    func configureOffset(animated: Bool) {
        if let hour = Int(initialHour) {
            if hour >= 0 && hour <= 23 {
                hoursCollectionView.scrollToItem(at: IndexPath(row: hour, section: 0), at: .centeredVertically, animated: animated)
                selectedHour = String(hour)
            }
        }
        
        if let minute = Int(initialMinute) {
            if minute >= 0 && minute <= 59 {
                minutesCollectionView.scrollToItem(at: IndexPath(row: minute, section: 0), at: .centeredVertically, animated: animated)
                selectedMinute = String(minute)
            }
        }
    }
    
    func configureGradientColor() {
        topGradientView.firstColor = topGradientColor
        topGradientView.secondColor = topGradientColor.withAlphaComponent(0.0)
        bottomGradientView.firstColor = bottomGradientColor
        bottomGradientView.secondColor = bottomGradientColor.withAlphaComponent(0.0)
    }
    
    open func hide(_ completion: (() -> ())?) {
        if springAnimations {
            hoursTrailingConstraint.constant = UIScreen.main.bounds.size.width / 2
            minutesLeadingConstraint.constant = UIScreen.main.bounds.size.width / 2
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                [unowned self] in
                self.topLineView.transform = CGAffineTransform(scaleX: 0.001, y: 1.0)
                self.bottomLineView.transform = CGAffineTransform(scaleX: 0.001, y: 1.0)
                self.centralLabel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.okButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.closeButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                }, completion: nil)
            
            UIView.animate(withDuration: 0.33, delay: 0.25, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [.curveEaseOut], animations: {
                [unowned self] in
                self.layoutIfNeeded()
                }, completion: { success in
                    if let completion = completion {
                        if self.fadeAnimation {
                            UIView.animate(withDuration: 0.25, animations: {
                                self.alpha = 0.0
                                }, completion: { success in
                                    completion()
                            })
                        } else {
                            self.alpha = 0.0
                        }
                    }
            })
        } else if fadeAnimation {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.0
                }, completion: { success in
                    if let completion = completion {
                        completion()
                    }
            })
        } else {
            self.alpha = 0.0
            if let completion = completion {
                completion()
            }
        }
    }
    
    open func show(_ completion: (() -> ())?) {
        topLineView.isHidden = areLinesHidden
        bottomLineView.isHidden = areLinesHidden
        
        topLineView.backgroundColor = linesColor
        bottomLineView.backgroundColor = linesColor
        pointsLabel.textColor = pointsColor
        
        configureGradientColor()
        
        if !scrollAnimations {
            self.configureOffset(animated: false)
        }
        
        if springAnimations {
            configureInitialComponents()
        }
        
        if fadeAnimation {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1.0
                }, completion: { success in
                    self.makeAppear(nil)
            })
        } else {
            self.alpha = 1.0
            self.makeAppear(nil)
        }
    }
    
    func makeAppear(_ completion: (() -> ())?) {
        
        if springAnimations {
            hoursTrailingConstraint.constant = 0
            minutesLeadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
                [unowned self] in
                self.layoutIfNeeded()
                }, completion: { success in
                    if self.scrollAnimations {
                        self.configureOffset(animated: self.scrollAnimations)
                    }
                    completion?()
            })
            
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [.curveEaseOut], animations: {
                [unowned self] in
                self.topLineView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.bottomLineView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.centralLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.okButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.closeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { success in
                    if let completion = completion {
                        completion()
                    }
            })
        } else {
            if scrollAnimations {
                self.configureOffset(animated: scrollAnimations)
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    open func dismiss(_ completion: (() -> ())?) {
        hide({
            if let completion = completion {
                completion()
            }
        })
        
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss({ [unowned self] in
            if let delegate = self.delegate {
                delegate.timePickerDidClose(self)
            }
        })
    }
    @IBAction func confirm(_ sender: UIButton) {
        dismiss({ [unowned self] in
            if let delegate = self.delegate {
                delegate.timePickerDidConfirm(self.selectedHour, minute: self.selectedMinute, timePicker: self)
            }
        })
    }
}
