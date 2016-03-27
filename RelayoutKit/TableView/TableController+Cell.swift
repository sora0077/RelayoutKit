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
        row.setIndexPath(indexPath)
        row.setSuperview(tableView)
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
        if cell.relayoutKit_defaultSeparatorInset == nil {
            cell.relayoutKit_defaultSeparatorInset = Wrapper(cell.separatorInset)
        }
        
        updateCell(cell, indexPath: indexPath, row: row)
        
        return cell
    }
    
    private func updateCell(cell: UITableViewCell, indexPath: NSIndexPath, row: TableRowProtocolInternal) {
        
        
        cell.indentationLevel = row.indentationLevel
        cell.indentationWidth = row.indentationWidth
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        cell.selected = row.selected
        
        cell.relayoutKit_row = Wrapper(row)
        row.setRenderer(cell)
        row.setSuperview(tableView)
        row.setIndexPath(indexPath)
        
        row.componentUpdate()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = cell.relayoutKit_row?.value {
            func applySeparatorStyle(style: UITableViewCellSeparatorStyle) {
                
                switch style {
                case .None:
                    cell.separatorInset.right = tableView.frame.width - cell.separatorInset.left
                default:
                    if let inset = row.separatorInset {
                        cell.separatorInset = inset
                    } else if let inset = cell.relayoutKit_defaultSeparatorInset?.value {
                        cell.separatorInset = inset
                    }
                }
            }
            let prev = sections[indexPath.section].internalRows[safe: indexPath.row - 1]
            let next = sections[indexPath.section].internalRows[safe: indexPath.row + 1]
            
            if let style = prev?.nextSeparatorStyle {
                applySeparatorStyle(style)
            } else if let style = next?.previousSeparatorStyle {
                applySeparatorStyle(style)
            } else {
                applySeparatorStyle(row.separatorStyle)
            }
            row.willDisplayCell()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = cell.relayoutKit_row?.value {
            row.didEndDisplayingCell()
            row.setRenderer(nil)
            cell.relayoutKit_row = nil
        }
    }
    
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.indentationLevel
    }
}

extension TableController {
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.willSelect(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.didSelect(indexPath)
        
        if !row.selected {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.willDeselect(indexPath)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.accessoryButtonTapped(indexPath)
    }
}


//MARK: - Editing Table Rows
extension TableController {
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.shouldIndentWhileEditing()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.editingStyle
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.editActions()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.commit(editingStyle: editingStyle)
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.titleForDeleteConfirmationButton
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        row.willBeginEditingRow()
    }
}

private extension TableController {
    
    func row(indexPath: NSIndexPath) -> TableRowProtocolInternal {
        return sections[indexPath.section].internalRows[indexPath.row]
    }
    
    func row(safe indexPath: NSIndexPath) -> TableRowProtocolInternal? {
        return sections[safe: indexPath.section]?.internalRows[safe: indexPath.row]
    }
}

extension TableController {
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let row = sections[indexPath.section].internalRows[indexPath.row]
        return row.canMove
    }
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        let source = row(sourceIndexPath)
        if let destination = row(safe: proposedDestinationIndexPath) {
            if source.canMove && destination.canMove {
                if source.willMove(to: destination) && destination.willMove(from: source) {
                    return proposedDestinationIndexPath
                }
            }
        } else {
            if source.canMove {
                return proposedDestinationIndexPath
            }
        }
        return sourceIndexPath
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let source = row(sourceIndexPath)
        
        sections[sourceIndexPath.section].removeAtIndex(sourceIndexPath.row)
        sections[destinationIndexPath.section].insert(source, atIndex: destinationIndexPath.row)
        
        for (idx, row) in sections[sourceIndexPath.section].internalRows.enumerate() {
            let indexPath = NSIndexPath(forRow: idx, inSection: sourceIndexPath.section)
            row.setIndexPath(indexPath)
        }
        for (idx, row) in sections[destinationIndexPath.section].internalRows.enumerate() {
            let indexPath = NSIndexPath(forRow: idx, inSection: destinationIndexPath.section)
            row.setIndexPath(indexPath)
        }
    }
}

private func pindexPath(indexPath: NSIndexPath) -> String {
    return "indexPath(row: \(indexPath.row), section: \(indexPath.section))"
}
