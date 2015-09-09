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
    
    public static var identifier: String {
        return "UITableViewCell"
    }
    
    public static func register(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: self.identifier)
    }
}

class TextTableRow<T: UITableViewCell where T: TableRowRenderer>: TableRow<T> {
    
    override init(uniqueIdentifier: String? = nil) {
        super.init(uniqueIdentifier: uniqueIdentifier)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.controller(self, sections: [TableSection()])
        
        let row = TextTableRow<UITableViewCell>()
        tableView[section: 0, row: 0] = row
        
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

