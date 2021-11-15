//
//  TextureAtlasTests.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import XCTest
@testable import Meadow

final class TextureAtlasTests: XCTestCase {
    
    func testSurfaceTileset() throws {
        
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        let operation = TextureAtlasOperation(season: .spring)
        
        let group = DispatchGroup()
        
        group.enter()
        
        operation.enqueue(on: queue) { result in
            
            switch result {
                
            case .failure: XCTFail()
            default: break
            }
            
            group.leave()
        }
        
        group.wait()
    }

    static var allTests = [
        ("testSurfaceTileset", testSurfaceTileset)
    ]
}
