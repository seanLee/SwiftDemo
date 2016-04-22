//
//  ViewController.swift
//  BullsEye
//
//  Created by sean on 16/4/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Variable
    var currentValue:Int = 0;
    var targetValue:Int = 0;
    var score:Int = 0;
    var round:Int = 0;
    
    let transition = TransitionAnimation();
    
    private lazy var submitBtn:UIButton = {
        let btn = UIButton();
        btn.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20);
        btn.setTitle("Hit Me", forState: UIControlState.Normal);
        btn.setTitleColor(UIColor(red: 96.0/255.0, green: 30.0/255.0, blue: 0, alpha: 1.0), forState: .Normal);
        btn.setBackgroundImage(UIImage(named: "Button-Normal"), forState: UIControlState.Normal);
        btn.setBackgroundImage(UIImage(named: "Button-Button-Highlighted"), forState: UIControlState.Highlighted);
        btn.addTarget(self, action:#selector(handleClick(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
        return btn;
    }();
    
    private lazy var infoLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "Pull the Bull's Eye as close as u can to:";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 16);
        lbl.textColor = UIColor.whiteColor();
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var scoreLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "100";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 20);
        lbl.textColor = UIColor.whiteColor();
        lbl.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var scoreSlider:UISlider = {
        let slider = UISlider();
        slider.minimumValue = 1;
        slider.maximumValue = 100;
        slider.value = 50;
        slider.setThumbImage(UIImage(named: "SliderThumb-Normal"), forState: UIControlState.Normal);
        slider.setThumbImage(UIImage(named: "SliderThumb-Highlighted"), forState: UIControlState.Highlighted);
        
        let insets = UIEdgeInsetsMake(0, 14, 0, 14);
        slider.setMinimumTrackImage(UIImage(named: "SliderTrackLeft")?.resizableImageWithCapInsets(insets), forState: UIControlState.Normal);
        slider.setMaximumTrackImage(UIImage(named: "SliderTrackRight")?.resizableImageWithCapInsets(insets), forState: UIControlState.Normal);
        slider.addTarget(self, action: #selector(sliderMoved(_:)), forControlEvents: UIControlEvents.ValueChanged);
        self.view.addSubview(slider);
        return slider;
    }();
    
    private lazy var minScoreLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "1";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 14);
        lbl.textColor = UIColor.whiteColor();
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var maxScoreLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "100";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 14);
        lbl.textColor = UIColor.whiteColor();
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var restartButton:UIButton = {
        let btn = UIButton();
        btn.setImage(UIImage(named: "StartOverIcon"), forState: UIControlState.Normal);
        btn.setBackgroundImage(UIImage(named: "SmallButton"), forState: UIControlState.Normal);
        btn.addTarget(self, action:#selector(restartClick(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
        return btn;
    }();
    
    private lazy var infoButton:UIButton = {
        let btn = UIButton();
        btn.setImage(UIImage(named: "InfoButton"), forState: UIControlState.Normal);
        btn.setBackgroundImage(UIImage(named: "SmallButton"), forState: UIControlState.Normal);
        btn.addTarget(self, action:#selector(showInfoClick(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
        return btn;
    }();
    
    private lazy var finalScoreInfoLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "Socre:";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 16);
        lbl.textColor = UIColor.whiteColor();
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var finalScoreLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "999999";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 20);
        lbl.textColor = UIColor.whiteColor();
        lbl.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var roundInfoLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "Round:";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 16);
        lbl.textColor = UIColor.whiteColor();
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    private lazy var roundLabel:UILabel = {
        let lbl = UILabel();
        lbl.text = "999999";
        lbl.font = UIFont(name: "Arial Rounded MT Bold", size: 20);
        lbl.textColor = UIColor.whiteColor();
        lbl.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(lbl);
        return lbl;
    }();
    
    // MARK: - Constraint
    private func constraintToSubview() {
        submitBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self.view);
            make.width.height.greaterThanOrEqualTo(0);
        };
        infoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(25);
            make.height.equalTo(20);
            make.width.greaterThanOrEqualTo(0);
        };
        scoreLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.infoLabel);
            make.left.equalTo(self.infoLabel.snp_right).offset(5);
            make.height.greaterThanOrEqualTo(0);
            make.width.equalTo(36)
        };
        scoreSlider.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.infoLabel.snp_bottom).offset(40);
            make.left.equalTo(self.infoLabel.snp_left).offset(-10);
            make.right.equalTo(self.scoreLabel.snp_right).offset(10);
        };
        minScoreLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.scoreSlider.snp_left).offset(-10);
            make.centerY.equalTo(self.scoreSlider);
            make.width.height.greaterThanOrEqualTo(0);
        };
        maxScoreLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.scoreSlider.snp_right).offset(10);
            make.centerY.equalTo(self.scoreSlider);
            make.width.height.greaterThanOrEqualTo(0);
        };
        restartButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.minScoreLabel);
            make.width.height.greaterThanOrEqualTo(0);
            make.bottom.equalTo(self.view).offset(-30);
        };
        infoButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.maxScoreLabel);
            make.width.height.greaterThanOrEqualTo(0);
            make.bottom.equalTo(self.view).offset(-30);
        };
        finalScoreInfoLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restartButton.snp_right).offset(50);
            make.centerY.equalTo(restartButton);
            make.width.height.greaterThanOrEqualTo(0);
        };
        finalScoreLabel.snp_makeConstraints { (make) in
            make.left.equalTo(finalScoreInfoLabel.snp_right).offset(5);
            make.centerY.equalTo(finalScoreInfoLabel);
            make.width.equalTo(72);
            make.height.greaterThanOrEqualTo(0);
        };
        roundInfoLabel.snp_makeConstraints { (make) in
            make.right.equalTo(roundLabel.snp_left).offset(-5);
            make.centerY.equalTo(roundLabel);
            make.width.height.greaterThanOrEqualTo(0);
        };
        roundLabel.snp_makeConstraints { (make) in
            make.right.equalTo(infoButton.snp_left).offset(-50);
            make.centerY.equalTo(infoButton);
            make.width.equalTo(36);
            make.height.greaterThanOrEqualTo(0);
        };
    }
    
    // MARK: - Lify Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //background
        self.view.layer.contents = UIImage(named: "Background")?.CGImage;
        
        initSubviews();
        
        startNewGame();
        updateLabelCount();
    }
    
    // MARK: - Action
    func handleClick(sender:AnyObject) {
        let difference = abs(targetValue - currentValue);
        
        var points = 100 - difference;
        
        let title:String;
        if difference == 0 {
            title = "Perfect!";
            points += 100;
        } else if difference < 5 {
            title = "You almost had it!";
            if difference == 1 {
                points += 50;
            }
        } else if difference < 10 {
            title = "Pretty good!";
        } else {
            title = "Not even close";
        }
        
        score += points;
        
        let message = "You scored \(points) points";
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.startNewRound();
            self.updateLabelCount();
        });
        alert.addAction(action);
        
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func restartClick(sendr:AnyObject) {
        startNewGame();
        updateLabelCount();
        
        let fadeAnimation = CATransition();
        fadeAnimation.type = kCATransitionFade;
        fadeAnimation.duration = 1;
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        view.layer.addAnimation(fadeAnimation, forKey: nil);
        
    }
    
    func showInfoClick(sender:AnyObject) {
        let vc = AboutViewController();
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom;
        vc.transitioningDelegate = self;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    func sliderMoved(slider:UISlider) {
        currentValue = lroundf(slider.value);
    }
    
    // MARK: - Private
    private func initSubviews() {
        self.constraintToSubview();
    }
    
    private func startNewRound() {
        scoreSlider.value = 50;
        currentValue = lroundf(self.scoreSlider.value);
        targetValue = 1 + Int(arc4random_uniform(100));
    }
    
    private func updateLabelCount() {
        scoreLabel.text = String(targetValue);
        finalScoreLabel.text = String(score);
        round += 1;
        roundLabel.text = String(round);
    }
    
    private func startNewGame() {
        score = 0;
        round = 0;
        startNewRound();
    }
}


extension ViewController:UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Prensent;
        transition.startPoint = self.view.center;
        transition.bubbleColor = UIColor.clearColor();
        return transition;
    };
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss;
        transition.startPoint = self.view.center;
        transition.bubbleColor = UIColor.clearColor();
        return transition
    }
}
