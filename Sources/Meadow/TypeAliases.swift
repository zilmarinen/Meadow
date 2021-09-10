//
//  TypeAliases.swift
//
//  Created by Zack Brown on 04/11/2020.
//

#if os(macOS)

    import Cocoa
    import AppKit

    public typealias MDWColor = NSColor
    public typealias MDWFloat = Double
    public typealias MDWImage = NSImage

#else

    import UIKit

    public typealias MDWColor = UIColor
    public typealias MDWFloat = Float
    public typealias MDWImage = UIImage

#endif

public typealias MDWScene = Scene
