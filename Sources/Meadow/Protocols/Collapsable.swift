//
//  Collapsable.swift
//
//  Created by Zack Brown on 07/12/2020.
//

protocol Collapsable {
    
    var coordinate: Coordinate { get }
    
    func collapse()
}

extension Array where Element == Collapsable {
    
    func collapse() {
        
        var remainder: [Collapsable] = []
        
        for i in 0..<count {
            
            let collapsable = self[i]
            
            if (collapsable.coordinate.x == collapsable.coordinate.z) || (collapsable.coordinate.x % 2 == 0 && collapsable.coordinate.z % 2 == 0) {
                
                collapsable.collapse()
            }
            else {
                
                remainder.append(collapsable)
            }
        }
        
        for collapsable in remainder {
            
            collapsable.collapse()
        }
    }
}
