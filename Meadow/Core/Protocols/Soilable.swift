//
//  Soilable.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public protocol SoilableChild {}

public protocol SoilableParent: class {
    
    func child(didBecomeDirty child: SoilableChild)
}

protocol Soilable: SoilableChild & SoilableParent {
    
    var ancestor: SoilableParent? { get }
    
    var isDirty: Bool { get set }
    
    @discardableResult func becomeDirty() -> Bool
    @discardableResult func clean() -> Bool
}

extension Soilable {
    
    @discardableResult func becomeDirty() -> Bool {
        
        guard !isDirty else { return false }
        
        isDirty = true
        
        ancestor?.child(didBecomeDirty: self)
        
        return true
    }
    
    public func child(didBecomeDirty child: SoilableChild) {
        
        becomeDirty()
    }
}
