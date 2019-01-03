//
//  PropsMaster.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

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
        
        self.lists = PropLists(lists: propLists.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.name > rhs.name
        }))
        
        self.props = Props(prototypes: propLists.flatMap { $0.prototypes } )
    }
}

extension PropsMaster {
    
    public struct PropLists: TreeParent {
        
        public typealias TreeChild = PropList
        
        let lists: [TreeChild]
        
        public var totalChildren: Int { return lists.count }
        
        public func child(at index: Int) -> PropList? {
            
            return lists[index]
        }
        
        public func index(of child: PropList) -> Int? {
            
            return lists.index(of: child)
        }
    }
    
    public func list(named: String) -> PropList? {
        
        let name = named.lowercased()
        
        return lists.lists.first { $0.name.lowercased() == name }
    }
}

extension PropsMaster {
    
    public struct Props: TreeParent {
        
        public typealias TreeChild = PropPrototype
        
        let prototypes: [TreeChild]
        
        public var totalChildren: Int { return prototypes.count }
        
        public func child(at index: Int) -> PropPrototype? {
            
            return prototypes[index]
        }
        
        public func index(of child: PropPrototype) -> Int? {
            
            return prototypes.index(of: child)
        }
    }
    
    public func prop(named: String) -> PropPrototype? {
        
        let name = named.lowercased()
        
        return props.prototypes.first { $0.name.lowercased() == name }
    }
}
