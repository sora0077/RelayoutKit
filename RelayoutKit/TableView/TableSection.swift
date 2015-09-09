//
//  TableSection.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

public struct TableSection {
 
    private(set) var internalRows: [TableRowProtocolInternal] = []
    
    public private(set) var rows: [TableRowProtocol] = []
    
    public init() {
        
    }
    
    subscript(index: Int) -> TableRowProtocol {
        set {
            internalRows[index] = newValue as! TableRowProtocolInternal
            rows[index] = newValue
        }
        get {
            return rows[index]
        }
    }
    
    mutating func append(row: TableRowProtocol) {
        internalRows.append(row as! TableRowProtocolInternal)
        rows.append(row)
    }
    
    mutating func insert(row: TableRowProtocol, atIndex index: Int) {
        internalRows.insert(row as! TableRowProtocolInternal, atIndex: index)
        rows.insert(row, atIndex: index)
    }
    
    mutating func extend(rows: [TableRowProtocol]) {
        internalRows.appendContentsOf(rows.map { $0 as! TableRowProtocolInternal })
        self.rows.appendContentsOf(rows)
    }
    
    mutating func removeAtIndex(index: Int) {
        internalRows.removeAtIndex(index)
        rows.removeAtIndex(index)
    }
}
