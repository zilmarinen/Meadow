//
//  Meadow+Types.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

public typealias MDWColor = UIColor
public typealias MDWFloat = Float
public typealias MDWImage = UIImage

#else

import AppKit

public typealias MDWColor = NSColor
public typealias MDWFloat = CGFloat
public typealias MDWImage = NSImage

#endif
