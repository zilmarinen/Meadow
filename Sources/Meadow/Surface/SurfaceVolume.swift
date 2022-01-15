//
//  SurfaceVolume.swift
//
//  Created by Zack Brown on 27/12/2021.
//

public enum SurfaceVolume: String, CaseIterable, Codable, Identifiable {
    
    public static var solids: [SurfaceVolume] = [.throne,
                                                 .crown]
    
    case crown
    case throne
    case mantle
    
    public var id: String { rawValue }
}
