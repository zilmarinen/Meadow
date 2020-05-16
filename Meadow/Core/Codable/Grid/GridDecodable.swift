//
//  GridDecodable.swift
//  Meadow
//
//  Created by Zack Brown on 22/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol GridDecodable {
    
    associatedtype JSON
    
    func decode(json: JSON)
}
