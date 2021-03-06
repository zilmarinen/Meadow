//
//  CameraController.swift
//
//  Created by Zack Brown on 16/12/2020.
//

import SceneKit

extension Camera {
    
    enum Constants {
        
        static let maximumZoom = 7.0
        static let minimumZoom = 1.0
    }
    
    public enum CameraState: State {
        
        case focus(node: SCNNode, cardinal: Cardinal, zoom: Double)
        
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
            
            case .focus(let node, let cardinal, let zoom):
                
                let rotation = Cardinal(rawValue: (cardinal.edge + direction.rawValue) % 4)
                
                state = .focus(node: node, cardinal: rotation, zoom: zoom)
            }
        }
        
        public func zoom(direction: Transform.Zoom) {
            
            switch state {
            
            case .focus(let node, let cardinal, let zoom):
                
                var zoomLevel = zoom
                
                switch direction {
                
                case .in(let delta):
                    
                    zoomLevel -= delta
                    
                case .out(let delta):
                    
                    zoomLevel += delta
                }
                
                zoomLevel = min(Constants.maximumZoom, zoomLevel)
                zoomLevel = max(Constants.minimumZoom, zoomLevel)
                
                state = .focus(node: node, cardinal: cardinal, zoom: zoomLevel)
            }
        }
        
        public func focus(node: SCNNode, cardinal: Cardinal? = nil, zoom: Double? = nil) {
            
            switch state {
            
            case .focus(_, let currentCadinal, let currentZoom):
                
                state = .focus(node: node, cardinal: cardinal ?? currentCadinal, zoom: zoom ?? currentZoom)
            }
        }
    }
}
