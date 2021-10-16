//
//  Error.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation

enum AssetError: Error {

    case missingAsset(String)
}

enum SeamStitchingError: Error {
    
    case droppedStitches([PortalSegue])
    case missingSeam(PortalSegue)
}

enum SceneMergingError: Error {
    
    case missingProp(String)
}
