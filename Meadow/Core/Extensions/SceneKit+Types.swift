//
//  SceneKit+Types.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import CoreGraphics

#if os(iOS)

import UIKit

public typealias SCNColor = UIColor
public typealias SCNFloat = Float

#else

import AppKit

public typealias SCNColor = NSColor
public typealias SCNFloat = CGFloat

#endif
