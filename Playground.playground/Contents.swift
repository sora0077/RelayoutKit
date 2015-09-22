//: Playground - noun: a place where people can play

import UIKit
import RelayoutKit

import XCPlayground

extension UITableViewCell: TableRowRenderer {
    
    public static func register(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: self.identifier)
    }
}

class TextTableRow<T: UITableViewCell where T: TableRowRenderer>: TableRow<T> {
    
    override init() {
        super.init()
    }
    
    override func componentDidMount() {
        super.componentDidMount()
        
        renderer?.textLabel?.text = "aaaaa"
    }
    
    
}


let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 300), style: .Plain)

tableView.controller(nil, sections: [TableSection()])


tableView[section: 0, row: 0] = TextTableRow<UITableViewCell>()
tableView[section: 0, row: 1] = TextTableRow<UITableViewCell>()
tableView[section: 0, row: 2] = TextTableRow<UITableViewCell>()
tableView[section: 0, row: 3] = TextTableRow<UITableViewCell>()


let preview = tableView



