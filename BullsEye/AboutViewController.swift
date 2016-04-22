//
//  AboutViewController.swift
//  BullsEye
//
//  Created by sean on 16/4/13.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import SnapKit

class AboutViewController: UIViewController {
    
    private lazy var webView:UIWebView = {
        let webView = UIWebView();
        if let htmlFile = NSBundle.mainBundle().pathForResource("BullsEye", ofType: "html") {
            if let htmlData = NSData(contentsOfFile:htmlFile) {
                let baseUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
                webView.loadData(htmlData, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: baseUrl);
            }
        }
        self.view.addSubview(webView);
        return webView;
    }();
    
    private lazy var closeButton:UIButton = {
        let btn = UIButton();
        btn.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20);
        btn.setTitle("Close", forState: UIControlState.Normal);
        btn.setTitleColor(UIColor(red: 96.0/255.0, green: 30.0/255.0, blue: 0, alpha: 1.0), forState: .Normal);
        btn.setBackgroundImage(UIImage(named: "Button-Normal"), forState: UIControlState.Normal);
        btn.setBackgroundImage(UIImage(named: "Button-Button-Highlighted"), forState: UIControlState.Highlighted);
        btn.addTarget(self, action:#selector(exitClick(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
        return btn;
    }();
    
    private func constraintToSubview() {
        webView.snp_makeConstraints { (make) in
            make.top.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(closeButton.snp_top).offset(-8);
        };
        
        closeButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-20);
            make.width.equalTo(100);
            make.height.equalTo(37);
        };
    };
    
    // MARK: - Private
    private func initSubviews() {
        self.constraintToSubview();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.layer.contents = UIImage(named: "Background")?.CGImage;
        self.initSubviews();
    }
}


extension AboutViewController {
    
    func exitClick(sendr:AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
}
