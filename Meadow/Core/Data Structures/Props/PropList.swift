//
//  PropList.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct PropList: Codable {
    
    public let name: String
    
    public let category: PropType
    
    public let props: [Prop]
    
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
}

extension PropList: Hashable {
    
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
        
        var propIntermediates: [Prop] = []
        
        propNames.forEach { propName in
            
            if let prop = Prop(named: propName) {
                
                propIntermediates.append(prop)
            }
        }
        
        self.props = propIntermediates
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.props.map { $0.name }, forKey: .props)
    }
}
