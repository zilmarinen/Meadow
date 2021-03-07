//
//  BlueprintController.swift
//
//  Created by Zack Brown on 27/12/2020.
//

import SceneKit

extension Blueprint {
    
    public enum BlueprintType {
        
        case add
        case remove
        case select
    }
    
    public enum BlueprintState: State {
        
        case empty
        case area(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case building(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case foliage(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case footpath(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case portal(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case prop(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        case terrain(bounds: GridBounds, blueprintType: BlueprintType, elevation: Int)
        
        public func shouldTransition(to newState: BlueprintState) -> Should<BlueprintState> {
            
            switch self {
            
            case .empty:
                
                return .continue
              
            case .area(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .area(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation ? .abort : .continue
                
                default: return .continue
                }
                
            case .building(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .building(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation ? .abort : .continue
                
                default: return .continue
                }
                
            case .foliage(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .foliage(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation  ? .abort : .continue
                
                default: return .continue
                }
                
            case .footpath(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .footpath(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation  ? .abort : .continue
                
                default: return .continue
                }
                
            case .portal(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .portal(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation  ? .abort : .continue
                
                default: return .continue
                }
                
            case .prop(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .prop (let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation  ? .abort : .continue
                
                default: return .continue
                }
                
            case .terrain(let bounds, let blueprintType, let elevation):
                
                switch newState {
                
                case .terrain(let newBounds, let newBlueprintType, let newElevation):
                    
                    return bounds == newBounds && blueprintType == newBlueprintType && elevation == newElevation  ? .abort : .continue
                
                default: return .continue
                }
            }
        }
    }
    
    public class BlueprintController: StateObserver<BlueprintState> {
        
        public func clear() {
            
            state = .empty
        }
        
        public func select(area bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .area(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(building bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .building(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(foliage bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .foliage(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(footpath bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .footpath(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(portal bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .portal(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(prop bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .prop(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
        
        public func select(terrain bounds: GridBounds, blueprintType: BlueprintType, elevation: Int = 0) {
            
            state = .terrain(bounds: bounds, blueprintType: blueprintType, elevation: elevation)
        }
    }
}
