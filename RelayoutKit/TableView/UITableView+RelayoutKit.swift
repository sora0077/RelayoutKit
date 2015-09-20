//
//  UITableView+RelayoutKit.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

public extension UITableView {
    
    func controller(responder: UIResponder?, sections: [TableSection] = [TableSection()]) {
        
        let controller = TableController(responder: responder, sections: sections)
        
        relayoutKit_controller = controller
        controller.tableView = self
    }
    
    func flush() {
        
        relayoutKit_controller.flush()
    }
    
    func transaction(block: () -> [TableTransaction]) {
        
        relayoutKit_controller.transaction(block)
    }
    
    func insert(row: TableRowProtocol, atIndex index: Int, section: Int, animation: UITableViewRowAnimation = .None) {
        
        self.transaction {[
            .Insert(row, atIndex: index, section: section, with: animation)
            ]
        }
    }
    
    func append(row: TableRowProtocol, atSection section: Int, animation: UITableViewRowAnimation = .None) {
        
        self.transaction {[
            .InsertLast(row, section: section, with: animation)
            ]
        }
    }
    
    func extend(rows: [TableRowProtocol], atSetcion section: Int, animation: UITableViewRowAnimation = .None) {
        
        self.transaction {
            rows.map { .InsertLast($0, section: section, with: animation) }
        }
    }
    
    subscript(section section: Int, row row: Int) -> TableRowProtocol {
        set {
            self[section: section, row: row, animation: .None] = newValue
        }
        get {
            return relayoutKit_controller.sections[section].internalRows[row]
        }
    }
    
    subscript(section section: Int, row row: Int, animation animation: UITableViewRowAnimation) -> TableRowProtocol {
        set {
            if relayoutKit_controller.sections[section].rows.count == row {
                self.transaction {[
                    .InsertLast(newValue, section: section, with: animation)
                ]}
            } else {
                self.transaction {[
                    .Replacement(newValue, atIndex: row, section: section, with: animation)
                ]}
            }
        }
        get {
            return relayoutKit_controller.sections[section].internalRows[row]
        }
    }
    
    subscript(indexPath indexPath: NSIndexPath) -> TableRowProtocol {
        set {
            self[section: indexPath.section, row: indexPath.row] = newValue
        }
        get {
            return self[section: indexPath.section, row: indexPath.row]
        }
    }
    
}

private var UITableView_relayoutKit_controller: UInt8 = 0
extension UITableView {
    
    var relayoutKit_controller: TableController! {
        set {
            objc_setAssociatedObject(self, &UITableView_relayoutKit_controller, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UITableView_relayoutKit_controller) as? TableController
        }
    }
}

