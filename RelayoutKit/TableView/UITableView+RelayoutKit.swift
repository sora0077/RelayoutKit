//
//  UITableView+RelayoutKit.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

private let defaultAnimation: UITableViewRowAnimation = .Automatic

private extension Array {
    
    init(count: Int, @autoclosure repeatedObject: () -> Element) {
        self.init((0..<count).map { _ in
            repeatedObject()
        })
    }
}

public extension UITableView {
    
    func controller(responder: UIResponder?, sections: Int = 1) {
        
        let controller = TableController(
            responder: responder,
            sections: Array(count: sections, repeatedObject: TableSection())
        )
        
        relayoutKit_controller = controller
        controller.tableView = self
    }
    
    func flush() {
        
        relayoutKit_controller.flush()
    }
    
    internal func transaction(block: () -> [TableTransaction]) {
        
        relayoutKit_controller.transaction(block)
    }
    
    internal func transaction(block: () -> TableTransaction?) {
        
        relayoutKit_controller.transaction({ block().map { [$0] } ?? [] })
    }
    
    func insert(row: TableRowProtocol, atIndex index: Int, section: Int, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            .Insert(row, atIndex: index, section: section, with: animation)
        }
    }
    
    func append(row: TableRowProtocol, atSection section: Int, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            .InsertLast(row, section: section, with: animation)
        }
    }
    
    func extend(rows: [TableRowProtocol], atSetcion section: Int, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            rows.map { .InsertLast($0, section: section, with: animation) }
        }
    }
    
    func remove(row: TableRowProtocol, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            .Remove(row, with: animation)
        }
    }
    
    func reload(row: TableRowProtocol, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            row.indexPath.map {
                .Replacement(row, atIndex: $0.row, section: $0.section, with: animation)
            }
        }
    }
    
    func replace(from from: TableRowProtocol, to: TableRowProtocol, animation: UITableViewRowAnimation = defaultAnimation) {
        
        transaction {
            from.indexPath.map {
                .Replacement(to, atIndex: $0.row, section: $0.section, with: animation)
            }
        }
    }
    
    subscript(section section: Int, row row: Int) -> TableRowProtocol? {
        set {
            self[section: section, row: row, animation: .None] = newValue
        }
        get {
            return self[section: section, row: row, animation: .None]
        }
    }
    
    subscript(section section: Int, row row: Int, animation animation: UITableViewRowAnimation) -> TableRowProtocol? {
        set {
            if let newValue = newValue {
                transaction { () -> TableTransaction? in
                    if self.relayoutKit_controller.sections[section].rows.count == row {
                        return .Insert(newValue, atIndex: row, section: section, with: animation)
                    } else {
                        return .Replacement(newValue, atIndex: row, section: section, with: animation)
                    }
                }
            } else {
                transaction {
                    .RemoveIndex(index: row, section: section, with: animation)
                }
            }
        }
        get {
            return relayoutKit_controller.sections[safe: section]?.internalRows[safe: row]
        }
    }
    
    subscript(indexPath indexPath: NSIndexPath) -> TableRowProtocol? {
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

