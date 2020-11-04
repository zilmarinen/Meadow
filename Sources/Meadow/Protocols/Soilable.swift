//
//  Soilable.swift
//
//  Created by Zack Brown on 03/11/2020.
//

protocol SoilableChild {
    
    var ancestor: SoilableParent? { get }
}

protocol SoilableParent: class {
    
    func child(didBecomeDirty child: SoilableChild)
}

protocol Soilable: SoilableChild & SoilableParent {
    
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
    
    func child(didBecomeDirty child: SoilableChild) {
        
        ancestor?.child(didBecomeDirty: child)
        
        becomeDirty()
    }
}
