//
//  SCNTechnique.swift
//
//  Created by Zack Brown on 28/05/2021.
//

import SceneKit

extension SCNTechnique {
    
    convenience init?(name: String, library: MTLLibrary) {
        
        guard let path = Bundle.module.path(forResource: name, ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String : Any] else { return nil }
        
        self.init(dictionary: dictionary)
        
        self.library = library
    }
}
