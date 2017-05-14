//
//  HomeCell.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model:HomeModel?{
        didSet{
            titleLabel.text = model!.title
            iconView.sd_setImage(with: URL(string: (model?.image)!), placeholderImage: plcaceHoldeImage)
            
            let values = UserDefaults.standard.object(forKey: KHadReades)
            if values != nil {
                let readNewsIdArray =  values as! [String]
                //是否点击过，点击过就灰色显示
                if let _ = readNewsIdArray.index(of: model!.id!) {
                    titleLabel.textColor = UIColor.lightGray
                } else {
                    self.titleLabel.textColor = UIColor.black
                }
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
