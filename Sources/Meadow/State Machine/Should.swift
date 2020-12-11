//
//  Should.swift
//
//  Created by Zack Brown on 10/12/2020.
//

public enum Should<T> {
    
    case `continue`
    case abort
    case redirect(T)
}
