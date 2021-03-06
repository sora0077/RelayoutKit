//
//  TableRow.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

//MARK: - TableRow
public class TableRow<T: UITableViewCell where T: TableRowRenderer>: NSObject, TableRowProtocol {
    
    public typealias RendererView = T
    
    public var estimatedSize: CGSize = CGSizeZero
    public var size: CGSize = CGSizeZero {
        didSet {
            estimatedSize = size
            if oldValue.height != size.height {
                superview?.reload(self)
            }
        }
    }
    public var indentationLevel: Int = 0
    public var indentationWidth: CGFloat = 10
    
    public var canMove: Bool = false
    
    public private(set) var indexPath: NSIndexPath? {
        didSet {
            if oldValue != indexPath && renderer != nil {
                componentUpdate()
            }
        }
    }
    public private(set) var outdated: Bool = true
    
    public var editingStyle: UITableViewCellEditingStyle = .None
    public var titleForDeleteConfirmationButton: String = "Delete"
    
    ///
    public var accessoryType: UITableViewCellAccessoryType = .None
    ///
    public var selectionStyle: UITableViewCellSelectionStyle = .Default
    
    public var separatorStyle: UITableViewCellSeparatorStyle = .SingleLine // SingleLineEtched is not supported
    public var separatorInset: UIEdgeInsets? = nil
    
    public var previousSeparatorStyle: UITableViewCellSeparatorStyle? // if value is not nil, `separatorStyle` is ignored
    public var nextSeparatorStyle: UITableViewCellSeparatorStyle? // if value is not nil, `separatorStyle` is ignored
    
    public var selected: Bool = false {
        didSet {
            renderer?.selected = selected
        }
    }
    
    public private(set) weak var renderer: RendererView?
    public private(set) weak var superview: UITableView? {
        didSet {
            outdated = superview == nil
        }
    }
    
    //
    
    public var didSelectRowAtIndexPath: (NSIndexPath -> Void)?
    public var accessoryButtonTappedWithIndexPath: (NSIndexPath -> Void)?
    
    //
    
    public override init() {
        self.estimatedSize.height = UITableViewAutomaticDimension
        self.size.height = UITableViewAutomaticDimension
    }
    
    public func componentDidMount() {}
    
    public func componentWillUnmount() {}
    
    public func componentUpdate() {}
    
    public func willDisplayCell() {}
    
    public func didEndDisplayingCell() {}
    
    
    
    public func willSelect(indexPath: NSIndexPath) -> NSIndexPath? { return indexPath }

    public func didSelect(indexPath: NSIndexPath) {
        selected = false
        
        didSelectRowAtIndexPath?(indexPath)
    }
    
    public func willDeselect(indexPath: NSIndexPath) -> NSIndexPath? { return nil }
    
    public func didDeselect(indexPath: NSIndexPath) {}
    
    
    
    public func accessoryButtonTapped(indexPath: NSIndexPath) {
        
        accessoryButtonTappedWithIndexPath?(indexPath)
    }
    
    public func shouldIndentWhileEditing() -> Bool {
        if editingStyle == .None {
            return false
        }
        return true
    }
    
    public func willBeginEditingRow() {}
    
    public func editActions() -> [UITableViewRowAction]? { return nil }
    
    public func commit(editingStyle editingStyle: UITableViewCellEditingStyle) {
    
        if case .Delete = editingStyle {
            remove()
        }
    }
    
    
    public func willMove(to to: TableRowProtocol) -> Bool { return true }
    
    public func willMove(from from: TableRowProtocol) -> Bool { return true }
}

public extension TableRow {
    
    var active: Bool {
        return renderer != nil
    }
    
    final func reload(animated animated: UITableViewRowAnimation = .Automatic) {
        superview?.reload(self, animation: animated)
    }
    
    final func replace(to to: TableRowProtocol, animated: UITableViewRowAnimation = .Automatic) {
        superview?.replace(from: self, to: to, animation: animated)
    }
    
    final func remove(animated animated: UITableViewRowAnimation = .Automatic) {
        superview?.remove(self, animation: animated)
    }
}

extension TableRow: TableRowProtocolInternal {
    
    static var identifier: String { return RendererView.identifier }
    
    static func register(tableView: UITableView) {
        RendererView.register(tableView)
    }
    
    final func setOutdated(flag: Bool) {
        outdated = flag
    }
    
    final func setSuperview(superview: UITableView?) {
        self.superview = superview
    }
    
    final func setIndexPath(indexPath: NSIndexPath?) {
        self.indexPath = indexPath
    }
    
    final func setRenderer(cell: UITableViewCell?) {
        
        if let cell = cell {
            renderer = cell as? RendererView
            assert(renderer != nil)
            componentDidMount()
        } else {
            if renderer != nil {
                componentWillUnmount()
            }
            renderer = nil
        }
    }
    
    final func getRenderer() -> UITableViewCell? {
        return renderer
    }
}



