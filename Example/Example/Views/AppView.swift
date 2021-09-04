//
//  AppView.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import CoreGraphics
import SceneKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject var controller: AppController
    
    @State var tapLocation: CGPoint = .zero
    
    var body: some View {
        
        ZStack {
            
            let tap = TapGesture().onEnded {
                
                controller.handle(input: tapLocation)
            }
                        
            let drag = DragGesture(minimumDistance: 0, coordinateSpace: .global) .onChanged { value in
                
                tapLocation = value.location
            }
            .sequenced(before: tap)
            
            SceneView(scene: controller.scene,
                      pointOfView: controller.scene.camera.jig,
                      options: [.rendersContinuously],
                      delegate: controller)
                .gesture(drag)
            
            switch controller.state {
                
            case .splash(let controller): SplashView(controller: controller)
            case .game(let controller): GameView(controller: controller)
            }
        }
    }
}
