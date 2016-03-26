//
//  ViewController.swift
//  RelayoutKitDemo
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import UIKit
import RelayoutKit

class ATableViewCell: UITableViewCell {
    
    
}

extension ATableViewCell: TableRowRenderer {
    
    static func register(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: self.identifier)
    }
}

class TextTableRow<T: UITableViewCell where T: TableRowRenderer>: TableRow<T> {
    
    let text: String
    
    init(text: String) {
        self.text = text
        super.init()
        
        canMove = true
        
        if let n = Int(text) where n % 4 == 0 {
            editingStyle = .Delete
            previousSeparatorStyle = .Some(.None)
            
        }
    }
    
    deinit {
        print("deinit")
    }
    
    override func componentUpdate() {
        super.componentUpdate()
        
        renderer?.textLabel?.text = "\(text) row:\(indexPath!.row) section: \(indexPath!.section)"
    }
    
    override func componentDidMount() {
        super.componentDidMount()
        
        print(text, " did mount")
    }
    override func componentWillUnmount() {
        super.componentDidMount()
        
        print(text, " will unmount")
    }
    
    override func willDisplayCell() {
        super.willDisplayCell()
        
//        renderer?.contentView.transform = CGAffineTransformMakeTranslation(0, -50)
//        UIView.animateWithDuration(0.5) {
//            renderer?.contentView.transform = CGAffineTransformIdentity
//        }
    }
    
    override func didSelect(indexPath: NSIndexPath) {
        super.didSelect(indexPath)
        
        size.height = 100
    }
}

class ViewController: UIViewController {
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.controller(self, sections: 1000)
        
        (0..<1000).forEach {
            tableView.append(TextTableRow<ATableViewCell>(text: "\($0)"), atSection: 0)
        }
        
        
        tableView[section: 0, row: 1] = TextTableRow<ATableViewCell>(text: "")
        
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

