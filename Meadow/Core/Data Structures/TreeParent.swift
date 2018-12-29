//
//  TreeParent.swift
//  Meadow
//
//  Created by Zack Brown on 28/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol TreeParent {
    
    associatedtype TreeChild
    
    var totalChildren: Int { get }
    
    func child(at index: Int) -> TreeChild?
    func index(of child: TreeChild) -> Int?
}
