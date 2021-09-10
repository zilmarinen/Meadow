//
//  SplashView.swift
//
//  Created by Zack Brown on 23/08/2021.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var model: SplashController.SplashViewModel
    
    var body: some View {
        
        switch model.viewState {
            
        case .application: Text("Application").foregroundColor(.black)
        case .developer: Text("Developer").foregroundColor(.black)
        default: EmptyView()
        }
    }
}
