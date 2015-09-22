//
//  ViewController.swift
//  RelayoutKitDemo
//
//  Created by 林達也 on 2015/09/10.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import UIKit
import RelayoutKit


extension UITableViewCell: TableRowRenderer {
    
    public static func register(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: self.identifier)
    }
}

class TextTableRow<T: UITableViewCell where T: TableRowRenderer>: TableRow<T> {
    
    let text: String
    
    init(text: String) {
        self.text = text
        super.init()
        
        if text == "8" {
            self.editingStyle = .Delete
        }
    }
    
    override func componentDidMount() {
        super.componentDidMount()
        
        renderer?.textLabel?.text = text
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
        tableView.controller(self, sections: [TableSection()])
        
        (0..<1000).forEach {
            tableView.append(TextTableRow<UITableViewCell>(text: "\($0)"), atSection: 0)
        }
        
        
        tableView[section: 0, row: 1] = TextTableRow<UITableViewCell>(text: "")
        
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

