//
//  TableRow.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation


protocol TableRowProtocolInternal: TableRowProtocol {
    
    
    static var identifier: String { get }

    static func register(tableView: UITableView)
    
    
    var uniqueIdentifier: String? { get }
    
    var estimatedSize: CGSize { get }
    
    //
    var accessoryType: UITableViewCellAccessoryType { get }
    var selectionStyle: UITableViewCellSelectionStyle { get }
    var separatorStyle: UITableViewCellSeparatorStyle { get }
    var separatorInset: UIEdgeInsets { get }
    var selected: Bool { get }
    
    
    func setRenderer(cell: UITableViewCell?)
    func getRenderer() -> UITableViewCell?
    
    func didSelect(indexPath: NSIndexPath)
    func accessoryButtonTapped(indexPath: NSIndexPath)
    
    func willDisplayCell()
    func didEndDisplayingCell()
}

//MARK: - TableRow
public class TableRow<T: UITableViewCell where T: TableRowRenderer>: NSObject, TableRowProtocol {
    
    public typealias RendererView = T
    
    public let uniqueIdentifier: String?
    
    public var estimatedSize: CGSize = CGSizeZero
    public var size: CGSize = CGSizeZero {
        didSet {
            estimatedSize = size
        }
    }
    
    ///
    public var accessoryType: UITableViewCellAccessoryType = .None
    ///
    public var selectionStyle: UITableViewCellSelectionStyle = .Default
    public var separatorStyle: UITableViewCellSeparatorStyle = .SingleLine // SingleLineEtched is not supported
    public var separatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    public var selected: Bool = false {
        didSet {
            renderer?.selected = selected
        }
    }
    
    public internal(set) weak var renderer: RendererView?
    public internal(set) weak var superview: UITableView?
    
    //
    
    public var didSelectRowAtIndexPath: (NSIndexPath -> Void)?
    public var accessoryButtonTappedWithIndexPath: (NSIndexPath -> Void)?
    
    //
    
    public init(uniqueIdentifier: String? = nil) {
        self.uniqueIdentifier = uniqueIdentifier
        self.estimatedSize.height = UITableViewAutomaticDimension
        self.size.height = UITableViewAutomaticDimension
    }
    
    public func didSelect(indexPath: NSIndexPath) {
        selected = false
        
        didSelectRowAtIndexPath?(indexPath)
    }
    
    public func accessoryButtonTapped(indexPath: NSIndexPath) {
        
        accessoryButtonTappedWithIndexPath?(indexPath)
    }
    
    public func componentDidMount() {
        
    }
    
    public func componentWillUnmount() {
        
    }
    
    public func willDisplayCell() {
        
    }

    public func didEndDisplayingCell() {
        
    }
}

public extension TableRow {
    
    var active: Bool {
        return renderer != nil
    }
}

extension TableRow: TableRowProtocolInternal {
    
    static var identifier: String { return RendererView.identifier }
    
    static func register(tableView: UITableView) {
        RendererView.register(tableView)
    }
    
    final func setRenderer(cell: UITableViewCell?) {
        
        if let cell = cell {
            renderer = cell as? RendererView
            assert(renderer != nil)
            self.componentDidMount()
        } else {
            self.componentWillUnmount()
            renderer = nil
        }
    }
    
    final func getRenderer() -> UITableViewCell? {
        return renderer
    }
}



