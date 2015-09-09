//
//  TableRowRenderer.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

//MARK: - TableRowRenderer
public protocol TableRowRenderer: ComponentRenderer {
    
    static var identifier: String { get }
    
    static func register(tableView: UITableView)
}
