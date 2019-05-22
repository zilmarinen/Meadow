//
//  SceneViewModel.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

extension SceneKitView {
    
    public enum ViewState: State {
        
        case empty(meadow: Meadow?)
        case scene(meadow: Meadow)
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    public class SceneViewModel: BaseViewModel<ViewState> {
        
        init() {
            
            super.init(initialState: .empty(meadow: nil))
        }
    }
}
