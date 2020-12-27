//
//  Transformable.swift
//
//  Created by Zack Brown on 23/12/2020.
//

public protocol Transformable {
    
    associatedtype T
    
    func translated(by translation: Vector) -> T
    func rotated(by rotation: Rotation) -> T
    func scaled(by scale: Vector) -> T
    func transformed(by transform: Transform) -> T
}
