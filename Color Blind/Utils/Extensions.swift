//
//  Extensions.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

extension Color {
    static func RGB ( red: Double, green: Double, blue: Double ) -> Color {
        return Color(red: red/255, green: green/255, blue: blue/255)
    }
}


let bounds = UIScreen.main.bounds

var globalOriginal: UIImage = UIImage()

var dicImages: [String: UIImage] = [:]
