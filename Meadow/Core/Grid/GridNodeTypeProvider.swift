//
//  GridNodeTypeProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridNodeTypeProvider {
    
    associatedtype NodeType: GridNodeType
    
    var nodeTypes: [NodeType] { get }
    
    var totalChildren: Int { get }
    
    func nodeType(at index: Int) -> NodeType?
    func index(of nodeType: NodeType) -> Int?
    func find(nodeType name: String) -> NodeType?
}

extension GridNodeTypeProvider {
    
    public func nodeType(at index: Int) -> NodeType? {
        
        return nodeTypes[index]
    }
    
    public func index(of nodeType: NodeType) -> Int? {
        
        return nodeTypes.index(of: nodeType)
    }
    
    public func find(nodeType name: String) -> NodeType? {
        
        return nodeTypes.first { nodeType -> Bool in
            
            return nodeType.name == name
        }
    }
}
