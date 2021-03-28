//
//  Tileset.swift
//
//  Created by Zack Brown on 15/12/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public protocol Tileset {
    
    associatedtype T = TilesetTile
    
    var image: MDWImage { get }
    var tiles: [T] { get }
}

extension Tileset {
    
    static func tileset(named: String) -> MDWImage? {
        
        #if os(macOS)
        
        return Bundle.module.image(forResource: named)
        
        #else
        
        return MDWImage(named: named, in: .module, with: nil)
        
        #endif
    }
    
    static func tilemap(named: String) -> NSDataAsset? {
        
        return NSDataAsset(name: named, bundle: .module)
    }
}
