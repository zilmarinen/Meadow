//
//  GridParent.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public protocol GridParent: GridObserver {
    
    associatedtype ChildType
    
    var children: [ChildType] { get }
    
    var totalChildren: Int { get }

    func child(at index: Int) -> ChildType?
    func index(of child: ChildType) -> Int?
    
    //func child(didBecomeDirty child: ChildType)
}

extension GridParent {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> ChildType? {
        
        return children[index]
    }
}

