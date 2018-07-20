//
//  GridParent.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

protocol GridParent: SceneGraphParent, GridObserver {
    
    associatedtype ChildType: Hashable
    
    var children: [ChildType] { get }
}
