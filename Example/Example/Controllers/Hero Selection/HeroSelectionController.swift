//
//  HeroSelectionController.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Foundation
import Meadow
import SwiftUI

class HeroSelectionController: ObservableObject {
    
    weak var parent: AppController?
    
    lazy var viewModel: HeroSelectionViewModel = { return HeroSelectionViewModel(controller: self) }()
    
    init(parent: AppController) {
        
        self.parent = parent
    }
}
