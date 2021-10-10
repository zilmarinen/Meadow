//
//  GameView.swift
//
//  Created by Zack Brown on 10/10/2021.
//

import SceneKit
import SwiftUI

struct GameView: View {
    
    @ObservedObject var model: GameViewModel
    
    var body: some View {
        
        switch model.state {
            
        case .idle: EmptyView()
            
        case .loading(let progress):
            
            VStack {
            
                Text("Loading")
                
                ProgressView(progress)
                .progressViewStyle(CircularProgressViewStyle())
            }
            
        case .rendering(let scene):
            
            SceneView(scene: scene, pointOfView: scene.camera.jig, options: .allowsCameraControl, delegate: scene)
        }
    }
}
