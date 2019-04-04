//
//  SceneView.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class SceneView: SCNView, CursorObserver {
    
    public lazy var viewModel = {
        
        return SceneViewModel()
    }()
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    public var cursorIdentifier: SceneView.Cursor.CallbackReference?
}

extension SceneView {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
        
            switch self.viewModel.state {
                
            case .empty(let meadow):
                
                self.scene = nil
                self.delegate = nil
                
                if let cursorIdentifier = self.cursorIdentifier {
                    
                    meadow?.input.cursor.unsubscribe(cursorIdentifier)
                }
                
            case .scene(let meadow):
                
                self.scene = meadow.scene
                self.delegate = meadow.scene
                
                if self.cursorIdentifier == nil {
                
                    self.cursorIdentifier = meadow.input.cursor.subscribe(self.stateDidChange(from:to:))
                }
            }
        }
    }
}

extension SceneView {
    
    public func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch self.viewModel.state {
            
        case .scene(let meadow):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
            
            switch to {
            
            case .idle(let position):
            
                guard let hit = meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let closest = meadow.scene.hitTest(hit)
                
                switch meadow.input.graticule.state {
                    
                case .tracking(let start, _, _, _):
                    
                    if start.coordinate != closest.coordinate {
                        
                        meadow.input.graticule.state = .tracking(start: closest, end: closest, yOffset: 0, inputType: .none)
                    }
                
                default: break
                }
            
            case .down(let position, let inputType),
                 .tracking(let position, let inputType),
                 .up(let position, let inputType):
                
                guard let hit = meadow.sceneView.hitTest(position.end, options: options).first, let camera = meadow.scene.cameraJib.camera else { break }
                
                let closest = meadow.scene.hitTest(hit)
                
                let scale = MDWFloat(camera.orthographicScale * 2)
                
                let offset = -Int((position.start.y - position.end.y) / scale)
                
                switch meadow.input.graticule.state {
                    
                case .tracking(let start, let end, let yOffset, _):
                    
                    switch to {
                        
                    case .down:
                        
                        meadow.input.graticule.state = .down(start: closest, inputType: inputType)
                        
                    case .tracking:
                        
                        if start.coordinate != closest.coordinate {
                            
                            meadow.input.graticule.state = .tracking(start: start, end: closest, yOffset: offset, inputType: inputType)
                        }
                    
                    case .up:
                        
                        meadow.input.graticule.state = .up(start: start, end: end, yOffset: yOffset, inputType: inputType)
                        
                    default: break
                    }
                    
                default: break
                }
            }
            
        default: break
        }
    }
}
