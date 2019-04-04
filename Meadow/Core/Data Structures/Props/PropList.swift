//
//  PropList.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct PropList: Codable {
    
    public let name: String
    
    public let category: PropType
    
    public let prototypes: [PropPrototype]
    
    public init?(named: String) {
        
        let resource = named.lowercased().replacingOccurrences(of: " ", with: "_")
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: resource, ofType: "proplist") else { return nil }
            
            let data = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            self = try decoder.decode(PropList.self, from: data)
        }
        catch {
            
            fatalError("Unable to load Proplist from file -> \(resource).proplist")
        }
    }
    
    public init(name: String, category: PropType, prototypes: [PropPrototype]) {
        
        self.name = name
        self.category = category
        self.prototypes = prototypes
    }
}

extension PropList: Equatable {
    
    public static func == (lhs: PropList, rhs: PropList) -> Bool {
        
        return lhs.name == rhs.name
    }
}

extension PropList {
    
    enum CodingKeys: CodingKey {
        
        case name
        case category
        case props
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(PropType.self, forKey: .category)
        
        let propNames = try container.decode([String].self, forKey: .props)
        
        var props: [PropPrototype] = []
        
        propNames.forEach { propName in
            
            if let prop = PropPrototype(named: propName) {
                
                props.append(prop)
            }
        }
        
        self.prototypes = props
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.prototypes.map { $0.name }, forKey: .props)
    }
}

extension PropList {
    
    public typealias ChildType = PropPrototype
    
    public var totalChildren: Int { return prototypes.count }
    
    public func child(at index: Int) -> ChildType? {
        
        return prototypes[index]
    }

    public func index(of child: ChildType) -> Int? {
        
        return prototypes.firstIndex(of: child)
    }
}
