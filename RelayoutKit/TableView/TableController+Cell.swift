//
//  TableController+Cell.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

//MARK: Cell

extension TableController {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.estimatedSize.height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        let clazz = row.dynamicType
        
        let identifier = clazz.identifier
        if !registeredCells.contains(identifier) {
            clazz.register(tableView)
            registeredCells.insert(identifier)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        cell.selected = row.selected
        
        cell.relayoutKit_row = Wrapper(row)
        row.setRenderer(cell)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = cell.relayoutKit_row?.value {
            row.willDisplayCell()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = cell.relayoutKit_row?.value {
            row.didEndDisplayingCell()
            row.setRenderer(nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.didSelect(indexPath)
        
        if !row.selected {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.accessoryButtonTapped(indexPath)
    }
}
