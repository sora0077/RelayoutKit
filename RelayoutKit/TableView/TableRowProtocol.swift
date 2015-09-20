//
//  TableRowProtocol.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

//MARK: - TableRowProtocol
public protocol TableRowProtocol: Component {
    
    var active: Bool { get }
    var indexPath: NSIndexPath? { get }
}


protocol TableRowProtocolInternal:
    TableRowProtocol,
    TableRowProtocolInternalConfiguringRowsForTheTableView,
    TableRowProtocolInternalManagingAccessoryViews,
    TableRowProtocolInternalManagingSelections,
    TableRowProtocolInternalEditingTableRow,
    TableRowProtocolInternalReorderingTableRows
{
    
    static var identifier: String { get }
    
    static func register(tableView: UITableView)
    
    
    //
    var accessoryType: UITableViewCellAccessoryType { get }
    var selectionStyle: UITableViewCellSelectionStyle { get }
    var separatorStyle: UITableViewCellSeparatorStyle { get }
    var separatorInset: UIEdgeInsets { get }
    var selected: Bool { get }
    
    //
    
    
    func setIndexPath(indexPath: NSIndexPath?)
    
    func setRenderer(cell: UITableViewCell?)
    func getRenderer() -> UITableViewCell?
    
    
    
    //
    
}

//MARK: - Configuring Rows for the Table View
protocol TableRowProtocolInternalConfiguringRowsForTheTableView {
    
    var estimatedSize: CGSize { get }
    var indentationLevel: Int { get }
    
    func willDisplayCell()
    func didEndDisplayingCell()
}

//MARK: - Managing Accessory Views
protocol TableRowProtocolInternalManagingAccessoryViews {
    
    func editActions() -> [UITableViewRowAction]?
    func accessoryButtonTapped(indexPath: NSIndexPath)
}

//MARK: - Managing Selections
protocol TableRowProtocolInternalManagingSelections {
    
    func willSelect(indexPath: NSIndexPath) -> NSIndexPath?
    func didSelect(indexPath: NSIndexPath)
    
    func willDeselect(indexPath: NSIndexPath) -> NSIndexPath?
    func didDeselect(indexPath: NSIndexPath)
}

//MARK: -
protocol TableRowProtocolInternalEditingTableRow {
    
    var editingStyle: UITableViewCellEditingStyle { get }
    var titleForDeleteConfirmationButton: String { get }
    
    
    func willBeginEditingRow()
    func didEndEditingRow()
    
    func shouldIndentWhileEditing() -> Bool
    
    func commit(editingStyle editingStyle: UITableViewCellEditingStyle)
}

//MARK: - Reordering Table Rows
protocol TableRowProtocolInternalReorderingTableRows {

    var canMove: Bool { get }
    
}
