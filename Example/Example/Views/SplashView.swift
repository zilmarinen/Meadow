//
//  SplashView.swift
//
//  Created by Zack Brown on 10/10/2021.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var model: SplashViewModel
    
    var body: some View {
        
        switch model.state {
            
        case .application:
            
            Text("Application Splash")
                .onReceive(model.timer) { timer in
                    
                    model.toggle()
                }
            
        case .developer:
            
            Text("Developer Splash")
                .onReceive(model.timer) { timer in
                    
                    model.toggle()
                }
        }
    }
}
