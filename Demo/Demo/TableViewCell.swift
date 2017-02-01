//
//  TableViewCell.swift
//  Demo
//
//  Created by mothule on 2017/02/01.
//  Copyright © 2017年 mothule. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var url:String? {
        didSet{
            if let url = url {
                dataImageView.load(fromURL: url)
                label.text = url
//                label.sizeToFit()
            }
        }
    }
    
    var height:CGFloat {
        get{
            let text:NSString = NSString(string: label.text!)
            let size = text.boundingRect(with: CGSize(width: label.bounds.width, height: 3000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontSize ], context: nil)
            return size.height
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
