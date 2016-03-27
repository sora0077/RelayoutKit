//
//  TableTransaction.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

enum TableTransaction {
    
    case Insert(TableRowProtocol, atIndex: Int, section: Int, with: UITableViewRowAnimation)
    case InsertLast(TableRowProtocol, section: Int, with: UITableViewRowAnimation)
    
    case RemoveIndex(index: Int, section: Int, with: UITableViewRowAnimation)
    case Remove(TableRowProtocol, with: UITableViewRowAnimation)
    case RemoveLast(section: Int, with: UITableViewRowAnimation)
    
    case Replacement(TableRowProtocol, atIndex: Int, section: Int, with: UITableViewRowAnimation)
    case ReplacementLast(TableRowProtocol, section: Int, with: UITableViewRowAnimation)
    
    case Setting([TableRowProtocol], section: Int, removal: UITableViewRowAnimation, insertion: UITableViewRowAnimation)
}
