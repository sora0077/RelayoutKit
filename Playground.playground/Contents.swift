//: Playground - noun: a place where people can play

import UIKit
import RelayoutKit

import XCPlayground

extension UITableViewCell: TableRowRenderer {
    
    public static var identifier: String {
        return "Cell"
    }
    
    public static func register(tableView: UITableView) {
        tableView.registerClass(self, forCellReuseIdentifier: self.identifier)
    }
}

class TextTableRow<T: UITableViewCell where T: TableRowRenderer>: TableRow<T> {
    
    override init(uniqueIdentifier: String? = nil) {
        super.init(uniqueIdentifier: uniqueIdentifier)
    }
    
    override func componentDidMount() {
        super.componentDidMount()
        
        renderer?.textLabel?.text = "aaaaa"
    }
}

let row = TextTableRow<UITableViewCell>()

let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 400), style: .Plain)

tableView.controller(nil, sections: [TableSection()])


tableView[section: 0, row: 0] = row


let preview = tableView
