//
//  CameraController.swift
//
//  Created by Zack Brown on 16/12/2020.
//

import SceneKit

extension Camera {
    
    enum Constants {
        
        static let maximumZoom = 14.0
        static let minimumZoom = 0.2
    }
    
    public enum CameraState: State {
        
        case focus(node: SCNNode, ordinal: Ordinal, zoom: Double)
        
        public func shouldTransition(to newState: CameraState) -> Should<CameraState> {
            
            return .continue
        }
    }
    
    public class CameraController: StateObserver<CameraState> {
        
        public enum Transform {
            
            public enum Rotation: Int {
                
                case anticlockwise = -1
                case clockwise = 1
            }
            
            public enum Zoom {
                
                case `in`(Double)
                case out(Double)
            }
        }
        
        public func rotate(direction: Transform.Rotation) {
            
            switch state {
            
            case .focus(let node, let ordinal, let zoom):
                
                let rotation = Ordinal(rawValue: (ordinal.rawValue + direction.rawValue) % 4) ?? .southEast
                
                state = .focus(node: node, ordinal: rotation, zoom: zoom)
            }
        }
        
        public func zoom(direction: Transform.Zoom) {
            
            switch state {
            
            case .focus(let node, let ordinal, let zoom):
                
                var zoomLevel = zoom
                
                switch direction {
                
                case .in(let delta),
                     .out(let delta):
                    
                    zoomLevel += delta
                }
                
                zoomLevel = min(1.0, zoomLevel)
                zoomLevel = max(0.1, zoomLevel)
                
                state = .focus(node: node, ordinal: ordinal, zoom: zoomLevel)
            }
        }
        
        public func focus(node: SCNNode, ordinal: Ordinal, zoom: Double) {
            
            state = .focus(node: node, ordinal: ordinal, zoom: zoom)
        }
    }
}
