//
//  UITableView+RelayoutKit.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

private var UITableView_relayoutKit_controller: UInt8 = 0
extension UITableView {
    
    
    public var sections: [TableSection] {
        get {
            return relayoutKit_controller.sections
        }
    }
    
    
    public func controller(responder: UIResponder?, sections: [TableSection] = [TableSection()]) {
        
        let controller = TableController(responder: responder, sections: sections)
        
        relayoutKit_controller = controller
        controller.tableView = self
    }
    
    public func flush() {
        
        relayoutKit_controller.flush()
    }
    
    public func transaction(block: () -> [TableTransaction]) {
        
        relayoutKit_controller.transaction(block)
    }
    
    public func rows(section: Int) -> [TableRowProtocol] {
        return relayoutKit_controller.sections[section].internalRows.map {
            $0 as TableRowProtocol
        }
    }
    
    public subscript(section section: Int) -> TableSection {
        set {
            relayoutKit_controller.sections[section] = newValue
        }
        get {
            return relayoutKit_controller.sections[section]
        }
    }
    
    public subscript(section section: Int, row row: Int) -> TableRowProtocol {
        set {
            self[section: section, row: row, animation: .None] = newValue
        }
        get {
            return relayoutKit_controller.sections[section].internalRows[row]
        }
    }
    
    public subscript(section section: Int, row row: Int, animation animation: UITableViewRowAnimation) -> TableRowProtocol {
        set {
            if relayoutKit_controller.sections[section].rows.count == row {
                relayoutKit_controller.transaction {[
                    .InsertLast(newValue, section: section, with: animation)
                ]}
            } else {
                relayoutKit_controller.transaction {[
                    .Replacement(newValue, atIndex: row, section: section, with: animation)
                ]}
            }
        }
        get {
            return relayoutKit_controller.sections[section].internalRows[row]
        }
    }
    
    public subscript(indexPath indexPath: NSIndexPath) -> TableRowProtocol {
        set {
            self[section: indexPath.section, row: indexPath.row] = newValue
        }
        get {
            return self[section: indexPath.section, row: indexPath.row]
        }
    }
    
    var relayoutKit_controller: TableController! {
        set {
            objc_setAssociatedObject(self, &UITableView_relayoutKit_controller, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UITableView_relayoutKit_controller) as? TableController
        }
    }
}

