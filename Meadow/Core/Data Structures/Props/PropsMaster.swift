//
//  PropsMaster.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class PropsMaster {
    
    public static let shared = PropsMaster()
    
    public let lists: PropLists
    
    public let props: Props
    
    init?() {
        
        guard let urls = Bundle.meadow.urls(forResourcesWithExtension: "proplist", subdirectory: nil) else { return nil }
        
        var propLists: [PropList] = []
        
        urls.forEach { url in
            
            if let filename = url.lastPathComponent.components(separatedBy: ".").first, let propList = PropList(named: filename) {
                
                propLists.append(propList)
            }
        }
        
        self.lists = PropLists(children: Tree<PropList>(propLists.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.name > rhs.name
        })))
        
        self.props = Props(children: Tree<PropPrototype>(propLists.flatMap { $0.prototypes }))
    }
}

extension PropsMaster {
    
    public struct PropLists {
        
        public let children: Tree<PropList>
    }
    
    public func list(named: String) -> PropList? {
        
        let name = named.lowercased()
        
        return lists.children.first { $0.name.lowercased() == name }
    }
}

extension PropsMaster {
    
    public struct Props {
        
        public let children: Tree<PropPrototype>
    }
    
    public func prop(named: String) -> PropPrototype? {
        
        let name = named.lowercased()
        
        return props.children.first { $0.name.lowercased() == name }
    }
}
