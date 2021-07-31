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
    
    static func asset(named: String, in bundle: Bundle) -> MDWImage? {
        
        #if os(macOS)
        
        return bundle.image(forResource: named)
        
        #else
        
        return MDWImage(named: named, in: bundle, with: nil)
        
        #endif
    }
}
