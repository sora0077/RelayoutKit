//
//  TableController.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

final class TableController: NSObject {
    
    var sections: [TableSection] = []
    
    weak var tableView: UITableView! {
        didSet {
            if let tableView = oldValue {
                detachTableView(tableView)
            }
            if let tableView = tableView {
                attachTableView(tableView)
            }
        }
    }
    
    weak var altDelegate: UITableViewDelegate?
    weak var altDataSource: UITableViewDataSource?
    
    var registeredCells: Set<String> = []
    
    weak var nextResponder: UIResponder?
    
    var transactionQueue: [[TableTransaction]] = []
    
    init(responder: UIResponder?, sections: [TableSection]) {
        
        self.nextResponder = responder
        self.sections = sections
        
        super.init()
    }
}

extension TableController {
    
    func flush() {
        
    }
    
    func transaction(@noescape block: () -> [TableTransaction]) {
        
        let transactions = block()
        
        func insertRow(row: TableRowProtocol, atIndex index: Int, section: Int, animation: UITableViewRowAnimation) {
            
            sections[section].insert(row, atIndex: index)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: section)], withRowAnimation: animation)
        }
        
        func extendRows(rows: [TableRowProtocol], section: Int, animation: UITableViewRowAnimation) {
            
            let index = sections[section].rows.count
            let indexPaths = (index..<(rows.count + index)).map { NSIndexPath(forRow: $0, inSection: section) }
            sections[section].extend(rows)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        }
        
        func reloadRow(row: TableRowProtocol, atIndex index: Int, section: Int, animation: UITableViewRowAnimation) {
            
            sections[section][index] = row
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: section)], withRowAnimation: animation)
        }
        
        func deleteRow(index: Int, section: Int, animation: UITableViewRowAnimation) {
            
            sections[section].removeAtIndex(index)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: section)], withRowAnimation: animation)
        }
        
        tableView.beginUpdates()
        for t in transactions {
            switch t {
            case let .Insert(row, atIndex: index, section: section, with: animation):
                insertRow(row, atIndex: index, section: section, animation: animation)
            case let .InsertLast(row, section: section, with: animation):
                let index = sections[section].rows.count
                insertRow(row, atIndex: index, section: section, animation: animation)
                
            case let .Replacement(row, atIndex: index, section: section, with: animation):
                reloadRow(row, atIndex: index, section: section, animation: animation)
            case let .ReplacementLast(row, section: section, with: animation):
                let index = sections[section].rows.count
                reloadRow(row, atIndex: index, section: section, animation: animation)
                
            case let .Remove(atIndex: index, section: section, with: animation):
                deleteRow(index, section: section, animation: animation)
            case let .RemoveLast(section: section, with: animation):
                let index = sections[section].rows.count
                deleteRow(index, section: section, animation: animation)
                
            case let .Setting(rows, section: section, removal: removal, insertion: insertion):
                for idx in 0..<sections[section].rows.count {
                    deleteRow(idx, section: section, animation: removal)
                }
                for (index, row) in rows.enumerate() {
                    insertRow(row, atIndex: index, section: section, animation: insertion)
                }
            }
        }
        tableView.endUpdates()
    }
}

extension TableController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].internalRows.count
    }
}

private extension TableController {
    
    func attachTableView(tableView: UITableView) {
        
        altDelegate = tableView.delegate
        altDataSource = tableView.dataSource
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func detachTableView(tableView: UITableView) {
        
        registeredCells.removeAll()
//        self.registeredHeaderFooterViews.removeAll(keepCapacity: true)
        
        tableView.delegate = altDelegate
        tableView.dataSource = altDataSource
        
        self.tableView = nil
    }
}

