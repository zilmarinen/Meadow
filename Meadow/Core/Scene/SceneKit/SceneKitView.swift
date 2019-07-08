//
//  SceneKitView.swift
//  Meadow
//
//  Created by Zack Brown on 25/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class SceneKitView: SCNView, CursorObserver {
    
    lazy var stateObserver = {
        
        return SceneViewStateObserver()
    }()
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
    
    public var cursorIdentifier: Cursor.CallbackReference?
    
    var lastUpdate: TimeInterval?
}

extension SceneKitView {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch self.stateObserver.state {
                
            case .empty(let meadow):
                
                self.delegate = nil
                self.isPlaying = false
                
                self.scene = nil
                
                if let cursorIdentifier = self.cursorIdentifier {
                    
                    meadow?.input.cursor.unsubscribe(cursorIdentifier)
                }
                
            case .scene(let meadow):
                
                self.lastUpdate = nil
                
                self.delegate = meadow
                self.isPlaying = true
                
                self.scene = meadow.scene
                
                if self.cursorIdentifier == nil {
                    
                    self.cursorIdentifier = meadow.input.cursor.subscribe(self.stateDidChange(from:to:))
                }
            }
        }
    }
}

extension SceneKitView {
    
    public func stateDidChange(from: CursorState?, to: CursorState) {
        
        switch self.stateObserver.state {
            
        case .scene(let meadow):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = meadow.view.hitTest(position, options: options).first else { break }
                
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
                
                guard let hit = meadow.view.hitTest(position.end, options: options).first, let camera = meadow.scene.cameraJib.camera else { break }
                
                let closest = meadow.scene.hitTest(hit)
                
                let scale = MDWFloat(camera.orthographicScale * 2)
                
                let offset = -Int(MDWFloat(position.start.y - position.end.y) / scale)
                
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
