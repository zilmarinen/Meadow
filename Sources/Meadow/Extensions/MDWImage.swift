//
//  MDWImage.swift
//
//  Created by Zack Brown on 21/05/2021.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public extension MDWImage {
    
    static func asset(named: String, in bundle: Bundle) throws -> MDWImage {
        
        #if os(macOS)
        
        guard let image = bundle.image(forResource: named) else { throw AssetError.missingAsset(named) }
        
        return image
        
        #else
        
        guard let image = MDWImage(named: named, in: bundle, with: nil) else { throw AssetError.missingAsset(named) }
        
        return image
        
        #endif
    }
}
