//
//  ColorManager.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//


import Foundation
import UIKit

/**
 Type of color blindness.
 
 - Deuteranomaly: Malfunctioning M-cone (green).
 - Deuteranopia: Missing. M-cone (green).
 - Protanomaly: Malfunctioning L-cone (red).
 - Protanopia: Missing L-cone (red).
 */
enum ColorBlindType : Int, CaseIterable {
    case deuteranomaly = 1
    case deuteranopia = 2
    case protanomaly = 3
    case protanopia = 4
    case tritanomaly = 5
    case tritanopia = 6
    case achromatomaly = 7
    case achromatopsia = 8
}

class CBColorBlindTypes: NSObject {
    class func getColorModified(_ type: ColorBlindType, red: Float, green: Float, blue: Float) -> Array<Float> {
        switch type {
        case .deuteranomaly:
            return [(red*0.80)+(green*0.20)+(blue*0),
                    (red*0.25833)+(green*0.74167)+(blue*0),
                    (red*0)+(green*0.14167)+(blue*0.85833)]
        case .protanopia:
            return [(red*0.56667)+(green*0.43333)+(blue*0),
                    (red*0.55833)+(green*0.44167)+(blue*0),
                    (red*0)+(green*0.24167)+(blue*0.75833)]
        case .deuteranopia:
            return [(red*0.625)+(green*0.375)+(blue*0),
                    (red*0.7)+(green*0.3)+(blue*0),
                    (red*0)+(green*0.3)+(blue*0.7)]
        case .protanomaly:
            return [(red*0.81667)+(green*0.18333)+(blue*0.0),
                    (red*0.33333)+(green*0.66667)+(blue*0.0),
                    (red*0.0)+(green*0.125)+(blue*0.875)]
        case .tritanopia:
            return [(red*0.95)+(green*0.05)+(blue*0.0),
                    (red*0)+(green*0.43)+(blue*0.56),
                    (red*0.0)+(green*0.4755)+(blue*0.525)]
        case .tritanomaly:
            return [(red*0.9667)+(green*0.033)+(blue*0.0),
                    (red*0)+(green*0.733)+(blue*0.2667),
                    (red*0.0)+(green*0.183)+(blue*0.8167)]
        case .achromatomaly:
            return [(red*0.618)+(green*0.32)+(blue*0.062),
                    (red*0.163)+(green*0.775)+(blue*0.062),
                    (red*0.163)+(green*0.32)+(blue*0.516)]
        case .achromatopsia:
            return [(red*0.299)+(green*0.587)+(blue*0.114),
                    (red*0.299)+(green*0.587)+(blue*0.114),
                    (red*0.299)+(green*0.587)+(blue*0.114)]
        }
    }
}

class CBPixelHelper: NSObject {
    class func processPixelsInImage(_ inputImage: UIImage, type: ColorBlindType) -> UIImage {
        let inputCGImage     = inputImage.cgImage
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage?.width
        let height           = inputCGImage?.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width!
        let bitmapInfo       = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)!
        context.draw(inputCGImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
        
        let pixelBuffer = UnsafeMutableRawPointer(context.data)
        let opaquePtr = OpaquePointer(pixelBuffer)
        let contextBuffer = UnsafeMutablePointer<UInt32>(opaquePtr)
        let currentPixel = contextBuffer
        
        var count = 0
        
        for _ in 0..<Int(height!) {
            for _ in 0..<Int(width!) {
                let pixel = currentPixel![count]
                
                let pred: Float = Float(red(pixel))
                let pblue: Float = Float(blue(pixel))
                let pgreen: Float = Float(green(pixel))
                
                let colors = CBColorBlindTypes.getColorModified(type, red:pred, green:pgreen, blue:pblue)
                currentPixel![count] = rgba(red: UInt8(colors[0]), green: UInt8(colors[1]), blue: UInt8(colors[2]), alpha: alpha(pixel))
                
                count += 1
            }
        }
        
        let outputCGImage = context.makeImage()
        let outputImage = UIImage(cgImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        
        return outputImage
    }
    
    class func alpha(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    class func red(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    class func green(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    class func blue(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    class func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
    }
}


let globalDicNames: [Int:String] = [
    1 : "Deuteranomaly",
    2 : "Deuteranopia",
    3 : "Protanomaly",
    4 : "Protanopia",
    5 : "Tritanomaly",
    6 : "Tritanopia",
    7 : "Achromatomaly",
    8 : "Achromatopsia",
]
