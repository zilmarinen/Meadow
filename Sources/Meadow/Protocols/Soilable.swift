//
//  Soilable.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public protocol SoilableChild {
    
    var ancestor: SoilableParent? { get }
}

public protocol SoilableParent: class {
    
    func child(didBecomeDirty child: SoilableChild)
}

public protocol Soilable: SoilableChild & SoilableParent {
    
    var isDirty: Bool { get set }
    
    @discardableResult func becomeDirty(recursive: Bool) -> Bool
    @discardableResult func clean() -> Bool
}

extension Soilable {
    
    @discardableResult public func becomeDirty(recursive: Bool = false) -> Bool {
        
        guard !isDirty else { return false }
        
        isDirty = true
        
        ancestor?.child(didBecomeDirty: self)
        
        return true
    }
    
    public func child(didBecomeDirty child: SoilableChild) {
        
        ancestor?.child(didBecomeDirty: child)
        
        becomeDirty()
    }
}
