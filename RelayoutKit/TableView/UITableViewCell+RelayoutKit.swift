//
//  UITableViewCell+RelayoutKit.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

private var UITableViewCell_relayoutKit_row: UInt8 = 0
extension UITableViewCell {
    
    var relayoutKit_row: Wrapper<TableRowProtocolInternal>? {
        set {
            objc_setAssociatedObject(self, &UITableViewCell_relayoutKit_row, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UITableViewCell_relayoutKit_row) as? Wrapper<TableRowProtocolInternal>
        }
    }
}
