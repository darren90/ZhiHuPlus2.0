//
//  HomeViewController.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    fileprivate let HomeIdentifier = "HomeIdentifier"
    fileprivate let HomeHeaderHeight = 154
    
    var bannerArray:[HomeModel] = []//轮播的数组
    var dataArray: [HomeModel] = []//轮播以下的数组
    
    var cycleView: SDCycleScrollView!
    var animator: ZFModalTransitionAnimator!
    var loadCircleView: PNCircleChart!//刷新控件
    var loadingView: UIActivityIndicatorView!//正在刷新控件
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //查看详情后，再次进入主界面，刷新，显示为灰色字体
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil , for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        tableView.rowHeight = 90//UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = true
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(HomeViewController.drawLeft))
        self.navigationItem.setLeftBarButton(leftButton, animated: false)
        
        setHeader()
        
        getHomeData { () -> () in
            
        }
    }
    
    func setHeader(){
         cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: KWidth, height: HomeHeaderHeight))
        cycleView.infiniteLoop = true
        cycleView.delegate = self
        cycleView.autoScrollTimeInterval = 5.0
        cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycleView.titleLabelTextFont = UIFont.systemFont(ofSize: 21)
        cycleView.titleLabelHeight = 60
        cycleView.titleLabelBackgroundColor = UIColor.clear
        cycleView.titleLabelAlpha = 1
        
        let headerView : ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderView(withSubView: cycleView, for: CGSize(width: KWidth, height: HomeHeaderHeight)) as! ParallaxHeaderView
        headerView.delegate = self
        self.tableView.tableHeaderView = headerView
    }
    

    //MARK - 加载网络数据
    func getHomeData(_ operate: (()->())?){
        
        APINetTools.get(APIZ_Latest, params: nil, success: { (json) -> Void in
            let homeData:Array = json["stories"] as! Array<[String:AnyObject]>
            let bannerData:Array = json["top_stories"] as! Array<[String:AnyObject]>
//            print(homeData)
            for i in 0 ..< homeData.count   {
                let homeId = String(describing: homeData[i]["id"]!)
                let images = homeData[i]["images"] as! [String]
                let img = images[0] as! String
                let title = homeData[i]["title"] as! String
    
                self.dataArray.append(HomeModel(id: homeId, image: img, title: title))
            }
            
            var imgs:[String] = []
            var titles:[String] = []
            
            for i in 0 ..< bannerData.count   {
                //                 print(bannerData[i])
                let id = String(describing: bannerData[i]["id"]!)
                let img = bannerData[i]["image"] as! String
                let title = bannerData[i]["title"] as! String
                imgs.append(img)
                titles.append(title)
                self.bannerArray.append(HomeModel(id: id, image: img, title: title))
            }
            self.cycleView.imageURLStringsGroup = imgs
            self.cycleView.titlesGroup = titles
            
            self.tableView.reloadData()
            operate!()
            }) { (error) -> Void in
                operate!()
        }
    }
    

    func drawLeft(){
        self.mm_drawerController .toggle(.left, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeIdentifier) as! HomeCell
        let model = dataArray[indexPath.row]
        cell.model = model
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //保证点击的是TableContentViewCell
        guard tableView.cellForRow(at: indexPath) is HomeCell else {
            return
        }
        
        jump2Toetail(indexPath.row,isCell: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Parallax效果
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderView(forScrollOffset: scrollView.contentOffset)

    }
    
    
    func jump2Toetail(_ index:Int, isCell:Bool){
        //
        //拿到webViewController
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "homeDetail") as!HomeDetailViewController
        detailVC.index = index
        
        let id:String = self.dataArray[index].id!
        detailVC.detailId = id
        
        
        if isCell {
            //取出已经看过详情的数据
            let values = UserDefaults.standard.object(forKey: KHadReades)
            if values != nil {
                var readNewsIdArray = values as! [String]
                readNewsIdArray.append(id)
                UserDefaults.standard.set(readNewsIdArray, forKey: KHadReades)
                UserDefaults.standard.synchronize()
            }else {
                UserDefaults.standard.set([], forKey: KHadReades)
                UserDefaults.standard.synchronize()
            }
        }
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: detailVC)
        self.animator.isDragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.right
        
        //设置webViewController
        detailVC.transitioningDelegate = self.animator
        
        //实施转场
        self.present(detailVC, animated: true) { () -> Void in
            
        }
    }


}

extension HomeViewController:SDCycleScrollViewDelegate,ParallaxHeaderViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        jump2Toetail(index,isCell: false)
    }
    
    func lockDirection() {
        self.tableView.contentOffset.y = -CGFloat(HomeHeaderHeight)
    }
    
    
}







