//
//  Soilable.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 31/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol SoilableDelegate
 @abstract Delegate callback for handling changes of observed Soilable items.
 */
public protocol SoilableDelegate {
    
    /*!
     @method didBecomeDirty:soilable
     @abstract Callback for soilable item to delegate change resolution upwards.
     */
    func didBecomeDirty(soilable: Soilable)
}

/*!
 @protocol Soilable
 @abstract Defines methods required to capture staleness of an item as well as executing any appropriate cleanup operations.
 */
public protocol Soilable {
    
    /*!
     @method becomeDirty
     @abstract Record that the item is dirty and should be cleaned.
     */
    func becomeDirty()
    
    /*!
     @method clean
     @abstract Perform any clean up operations required to clean the item.
     */
    func clean() -> Bool
}
