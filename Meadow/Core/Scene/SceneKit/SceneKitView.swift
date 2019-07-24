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
        
        return SceneViewStateObserver(initialState: .empty(meadow: nil))
    }()
    
    public lazy var hud = {
        
        return HUDStateObserver(initialState: .empty)
    }()
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        print("SceneKitView -> awakeFromNib")
        stateObserver.subscribe(stateDidChange(from:to:))
        hud.subscribe(stateDidChange(from:to:))
    }
    
    public var cursorIdentifier: Cursor.CallbackReference?
    
    var lastUpdate: TimeInterval?
}

extension SceneKitView {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let meadow):
                
                print("SceneKitView -> empty")
                
                self.delegate = nil
                self.isPlaying = false
                
                self.scene = nil
                
                if let cursorIdentifier = self.cursorIdentifier {
                    
                    meadow?.input.cursor.unsubscribe(cursorIdentifier)
                }
                
                self.cursorIdentifier = nil
                
            case .scene(let meadow, let scene):
                
                print("SceneKitView -> scene")
                
                self.lastUpdate = nil
                
                self.delegate = meadow
                self.isPlaying = true
                
                self.scene = scene
                
                if self.cursorIdentifier == nil {
                    
                    self.cursorIdentifier = meadow.input.cursor.subscribe(self.stateDidChange(from:to:))
                }
            }
        }
    }
}

extension SceneKitView {
    
    func stateDidChange(from: HUDState?, to: HUDState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty:
                
                self.overlaySKScene = nil
                
            case .scene(let scene):
                
                self.overlaySKScene = scene
            }
        }
    }
}

extension SceneKitView {
    
    public func stateDidChange(from: CursorState?, to: CursorState) {
        
        switch stateObserver.state {
            
        case .scene(let meadow, let scene):
            
            switch scene.model.state {
                
            case .scene(let world):
                
                let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: world,
                                                         SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
                
                switch to {
                    
                case .idle(let position):
                    
                    guard let hit = meadow.view.hitTest(position, options: options).first, let closest = scene.hitTest(hit) else { break }
                    
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
                    
                    guard let hit = meadow.view.hitTest(position.end, options: options).first, let closest = scene.hitTest(hit), let camera = scene.cameraJib.camera else { break }
                    
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
            
        default: break
        }
    }
}
