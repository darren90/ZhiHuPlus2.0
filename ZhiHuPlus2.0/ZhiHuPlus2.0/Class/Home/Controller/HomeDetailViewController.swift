//
//  HomeDetailViewController.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit
import SwiftyJSON



class HomeDetailViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    //暴露的参数
    var index = 1
    var detailId = ""
    
    //MARK：头部的几个自定义控件
    var topImgView:UIImageView!
    var headerView: ParallaxHeaderView!
    var blurView: GradientView!
    var titleLabel: myUILabel!
    var sourceLabel: UILabel!
    
    let loadingView: LoadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: CGFloat(KWidth), height: 30))
    
    
    var isHadImg = true
    let orginalHeight: CGFloat = 223
    var imageUrl = ""//图片
    var image_source = ""
    var share_url = ""
    var type = ""
    var titleStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailData(detailId)
        
        //避免因含有navBar而对scrollInsets做自动调整
        self.automaticallyAdjustsScrollViewInsets = false
        
        //避免webScrollView的ContentView过长 挡住底层View
        self.view.clipsToBounds = true
        
        //隐藏默认返回button但保留左划返回
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //webView的一些设置
        webView.addSubview(loadingView)//添加进度条
        webView.scrollView.delegate = self
        webView.scrollView.clipsToBounds = false
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.alwaysBounceHorizontal = false
        
        setUPSubViews()
    }
    
    
    fileprivate func setUPSubViews (){
        blurView = GradientView(frame: CGRect(x: 0, y: -85, width: self.view.frame.width, height: orginalHeight + 85), type: TRANSPARENT_GRADIENT_TWICE_TYPE)
        
        //设置顶部图片
        topImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: orginalHeight))
        topImgView.contentMode = .scaleAspectFill
        topImgView.addSubview(blurView)
        
        
        //设置顶部图片上的titleLabel
        titleLabel = myUILabel(frame: CGRect(x: 15, y: orginalHeight - 80, width: self.view.frame.width - 30, height: 60))
        titleLabel.font = UIFont(name: "STHeitiSC-Medium", size: 21)
        titleLabel.textColor = UIColor.white
        titleLabel.shadowColor = UIColor.black
        titleLabel.shadowOffset = CGSize(width: 0, height: 1)
        titleLabel.verticalAlignment = VerticalAlignmentBottom
        titleLabel.numberOfLines = 0
        topImgView.addSubview(titleLabel)
        
        //设置Image上的Image_sourceLabel
        sourceLabel = UILabel(frame: CGRect(x: 15, y: orginalHeight - 22, width: self.view.frame.width - 30, height: 15))
        sourceLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        sourceLabel.textColor = UIColor.lightText
        sourceLabel.textAlignment = NSTextAlignment.right
        topImgView.addSubview(sourceLabel)
        
        
        //将其添加到ParallaxView
        headerView = ParallaxHeaderView.parallaxWebHeaderView(withSubView: topImgView, for: CGSize(width: self.view.frame.width, height: orginalHeight)) as! ParallaxHeaderView
        headerView.delegate = self
        
        //将ParallaxView添加到webView下层的scrollView上
        self.webView.scrollView.addSubview(headerView)
    }
    
    
    
    //加载网页详情数据
    fileprivate func loadDetailData(_ id:String){
        let httpUrl:String = "http://news-at.zhihu.com/api/4/news/" + id
        
        //拉去数据
        APINetTools.get(httpUrl, params: nil, success: { (json) -> Void in
            print(json)
            let bodyStr = json["body"] as! String
            let cssStr:String = json["css"]!![0] as! String
            
            if let _ = JSON(json)["image"].string{
                self.imageUrl = json["image"] as! String
                self.image_source = json["image_source"] as! String
                self.share_url = json["share_url"] as! String
                self.titleStr = json["title"] as! String
                self.isHadImg = true
            }else{
                self.isHadImg = false
            }
            
            var html = "<html> <head>"
            html += "<link rel=\"stylesheet\" href="
            html += cssStr
            html += "</head>"
            html += bodyStr
            html += "</body> </html>"
            
            
            //加载网页数据OK
            self.webView.loadHTMLString(html, baseURL: nil)
            
            self.topImgView.sd_setImage(with: URL(string: self.imageUrl))
            self.titleLabel.text =  self.titleStr
            self.sourceLabel.text = "图片：" + self.image_source
            }) { (error) -> Void in
                print("获取数据失败")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 

}


extension HomeDetailViewController:UIScrollViewDelegate,UIWebViewDelegate ,ParallaxHeaderViewDelegate{
    //MARK - webView的代理
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadingView.startLoadProgressAnimation()
        
        print(#function)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(#function)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.endLoadProgressAnimation()
        
        print(#function)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //        print("offsetY:\(offsetY)")
        if offsetY < 0 {//设置图片的放大效果
            //不断设置titleLabel及sourceLabel以保证frame正确
            titleLabel.frame = CGRect(x: 15, y: orginalHeight - 80 - offsetY, width: self.view.frame.width - 30, height: 60)
            sourceLabel.frame = CGRect(x: 15, y: orginalHeight - 20 - offsetY, width: self.view.frame.width - 30, height: 15)
            //保证frame正确
            blurView.frame = CGRect(x: 0, y: -85 - offsetY, width: self.view.frame.width, height: orginalHeight + 85)
            
            topImgView.bringSubview(toFront: titleLabel)
            topImgView.bringSubview(toFront: sourceLabel)
        }
        
        headerView.layoutWebHeaderView(forScrollOffset: scrollView.contentOffset)
    }

    //MARK  - ParallaxHeaderViewDelegate代理
    //设置滑动极限 修改该值需要一并更改layoutWebHeaderViewForScrollViewOffset中的对应值
    func lockDirection() {
        self.webView.scrollView.contentOffset.y = -85
    }
}
