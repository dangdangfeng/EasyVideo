//
//  NSString+QNPlayer.swift
//  Videos
//
//  Created by taoxiaofei on 2018/5/24.
//  Copyright © 2018年 xxx. All rights reserved.
//

import UIKit

extension String {
    func qntextSize(withFont font: UIFont) -> CGSize {
        if self.isEmpty {
            return .zero
        }
        let text = NSString.init(string: self)
        let size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
        return size
    }
    
    func qnsize(withFont font: UIFont, constraintWidth width :CGFloat) -> CGSize {
        let text = NSString.init(string: self)
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
        return size
    }
}
