//
//  ContentView.swift
//  Shared
//
//  Created by Zack Brown on 18/08/2021.
//

import SceneKit
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var controller: Controller
    
    var body: some View {
        
        ZStack {
            
            SceneView(scene: controller.scene ?? SCNScene(), options: [.allowsCameraControl,
                                                                       .rendersContinuously], delegate: controller)
            
            VStack {
             
                switch controller.state {
                    
                case .application:
                    
                    Text("Application")
                    
                case .developer:
                    
                    Text("Developer")
                    
                case .loading:
                    
                    Text("Loading")
                    
                case .scene:
                    
                    Text("Scene")
                }
            }.foregroundColor(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView(controller: .init())
    }
}
