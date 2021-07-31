//
//  Edgeset.swift
//
//  Created by Zack Brown on 15/12/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

protocol Edgeset {
    
    associatedtype E = TilesetTile
    
    var image: MDWImage { get }
    var edges: [E] { get }
}

extension Edgeset {
    
    static func edgeset(named: String) -> MDWImage? {
        
        return MDWImage.asset(named: named, in: .module)
    }
    
    static func edgemap(named: String) -> NSDataAsset? {
        
        return NSDataAsset(name: named, bundle: .module)
    }
}
