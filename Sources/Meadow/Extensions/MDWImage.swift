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

extension MDWImage {
    
    static func asset(named: String) -> MDWImage? {
        
        #if os(macOS)
        
        return Bundle.module.image(forResource: named)
        
        #else
        
        return MDWImage(named: named, in: .module, with: nil)
        
        #endif
    }
}
