//
//  LaunchViewController.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit
import SwiftyJSON

class LaunchViewController: UIViewController {
    @IBOutlet weak var lunchImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        loadData()
    }
    
    func loadData(){
        APINetTools.get("http://news-at.zhihu.com/api/4/start-image/1080*1776", params: nil, success: { (json) -> Void in
//            print(json)
            let imgStr = JSON(json)["img"].string
            if let imgUrl:String = imgStr {
                self.lunchImgView.sd_setImage(with: URL(string: imgUrl), completed: { (_, _, _, _) -> Void in
                    self.lunchImgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                        self.lunchImgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.view.alpha = 0.8
                        
                        }, completion: { (_) -> Void in
                            NotificationCenter.default.post(name: Notification.Name(rawValue: LunchLoadNotication), object: nil)
                    })
                })
            }else{
                self.lunchImgView.image = UIImage(named: "DemoLaunchImage")
                NotificationCenter.default.post(name: Notification.Name(rawValue: LunchLoadNotication), object: nil)
            }
            
            }) { (error) -> Void in
                self.lunchImgView.image = UIImage(named: "DemoLaunchImage")
                NotificationCenter.default.post(name: Notification.Name(rawValue: LunchLoadNotication), object: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
