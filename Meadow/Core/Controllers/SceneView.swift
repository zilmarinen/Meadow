//
//  SceneView.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class SceneView: SCNView {
    
    public lazy var viewModel = {
        
        return SceneViewModel()
    }()
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneView {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch viewModel.state {
            
        case .empty:
            
            self.scene = nil
            self.delegate = nil
            
        case .scene(let scene, _):
            
            self.scene = scene
            self.delegate = scene
        }
    }
}
