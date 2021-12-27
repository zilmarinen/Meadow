//
//  Error.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation

public enum AssetError: Error {

    case missingAsset(String)
}

public enum SceneLoadingError: Error {
    
    case invalidDevice
}

public enum SeamStitchingError: Error {
    
    case droppedStitches([PortalSegue])
    case missingSeam(PortalSegue)
}

public enum SceneMergingError: Error {
    
    case missingProp(String)
}
