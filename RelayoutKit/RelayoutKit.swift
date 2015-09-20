//
//  RelayoutKit.swift
//  RelayoutKit
//
//  Created by 林達也 on 2015/09/09.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

public var Logger: ((Any...) -> Void)?

public protocol Component {
    
    var size: CGSize { get }
    
    func componentDidMount()
    func componentWillUnmount()
    
}

public extension Component {
    
}

public protocol ComponentRenderer {
    
}



class Wrapper<T> {
    
    let value: T
    
    init(_ v: T) {
        value = v
    }
}