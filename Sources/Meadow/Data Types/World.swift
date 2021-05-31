//
//  World.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public enum World {
    
    public enum Constants {
        
        public static let floor = 0
        public static let ceiling = 50
        public static let slope: Double = 0.25
        public static let step = 2
        
        public static let chunkSize = 10
        public static let volumeSize: Double = 0.5
        
        public static let yScalar = 1.0 / Double(ceiling)
    }
}
