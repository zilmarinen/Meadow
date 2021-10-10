//
//  TextureAtlas.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation

public struct TextureAtlas {
    
    public let season: Season
    
    public let bridges: BridgeAtlas
    public let buildings: BuildingAtlas
    public let foliage: FoliageAtlas
    public let footpath: FootpathAtlas
    public let surface: SurfaceAtlas
    public let walls: WallAtlas
    
    init(season: Season) throws {
        
        do {
            
            self.season = season
            self.bridges = try BridgeAtlas(season: season)
            self.buildings = try BuildingAtlas(season: season)
            self.foliage = try FoliageAtlas(season: season)
            self.footpath = try FootpathAtlas(season: season)
            self.surface = try SurfaceAtlas(season: season)
            self.walls = try WallAtlas(season: season)
        }
        catch {
            
            throw(error)
        }
    }
}
