//
//  GridChild.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

protocol GridChild: SceneGraphChild {
    
    associatedtype ParentType
    
    var superNode: ParentType? { get }
    
    var volume: Volume { get }
}
