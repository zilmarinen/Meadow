//
//  PriorityQueueNode.swift
//  Meadow
//
//  Created by Zack Brown on 21/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

protocol PriorityQueueNode: Equatable {
    
    var priority: Int { get }
}
