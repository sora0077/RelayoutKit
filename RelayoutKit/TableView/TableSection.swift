//
//  TableSection.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

public final class TableSection {
 
    private(set) var internalRows: [TableRowProtocolInternal] = []
    
    public private(set) var rows: [TableRowProtocol] = []
    
    init() {
        
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
    
    func append(row: TableRowProtocol) {
        internalRows.append(row as! TableRowProtocolInternal)
        rows.append(row)
    }
    
    func insert(row: TableRowProtocol, atIndex index: Int) {
        internalRows.insert(row as! TableRowProtocolInternal, atIndex: index)
        rows.insert(row, atIndex: index)
    }
    
    func extend(rows: [TableRowProtocol]) {
        internalRows.appendContentsOf(rows.map { $0 as! TableRowProtocolInternal })
        self.rows.appendContentsOf(rows)
    }
    
    func removeAtIndex(index: Int) -> TableRowProtocol {
        internalRows.removeAtIndex(index)
        return rows.removeAtIndex(index)
    }
}
