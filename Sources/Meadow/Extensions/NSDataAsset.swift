//
//  NSDataAsset.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

extension NSDataAsset {
    
    public static func asset(named: String, in bundle: Bundle) throws -> NSDataAsset {
        
        guard let asset = NSDataAsset(name: named, bundle: bundle) else { throw AssetError.missingAsset(named) }
        
        return asset
    }
}
