//
//  Colors.swift
//  MTGLifeCounter2
//
//  Created by Orion Edwards on 19/09/14.
//  Copyright (c) 2014 Orion Edwards. All rights reserved.
//

import SwiftUI

enum MtgColor : Int {
    case white, blue, black, red, green // basic
    case whiteBlue, blueBlack, blackRed, redGreen, greenWhite // allied
    case whiteBlack, blueRed, blackGreen, redWhite, greenBlue // enemy
    
    var displayName:String {
        get {
            switch self {
            case .white: return "White"
            case .blue: return "Blue"
            case .black: return "Black"
            case .red: return "Red"
            case .green: return "Green"
            case .whiteBlue: return "Azorius"
            case .blueBlack: return "Dimir"
            case .blackRed: return "Rakdos"
            case .redGreen: return "Gruul"
            case .greenWhite: return "Selesnya"
            case .whiteBlack: return "Orzhov"
            case .blueRed: return "Izzet"
            case .blackGreen: return "Golgari"
            case .redWhite: return "Boros"
            case .greenBlue: return "Simic"
            }
        }
    }
    
    static func First() -> MtgColor {
        return white
    }
    
    static func Last() -> MtgColor {
        return greenBlue
    }
    
    func lookup(_ primary:Bool) -> Color {
        switch primary {
        case true:
            switch self {
            case .white, .whiteBlue, .whiteBlack:
                return Color(red: 1.0, green: 1.0, blue: 1.0)
            case .blue, .blueBlack, .blueRed:
                return Color(red: 0.0, green: 0.22, blue: 0.72)
            case .black, .blackRed, .blackGreen:
                return Color(red: 0.12, green: 0.19, blue: 0.25)
            case .red, .redGreen, .redWhite:
                return Color(red: 0.84, green: 0.04, blue: 0.07)
            case .green, .greenWhite, .greenBlue:
                return Color(red: 0.15, green: 0.68, blue: 0.27)
            }
        case false:
            switch self {
            case .white, .greenWhite, .redWhite:
                return Color(red: 0.97, green: 0.92, blue: 0.9)
            case .blue, .whiteBlue, .greenBlue:
                return Color(red: 0.2, green: 0.30, blue: 1.00)
            case .black, .blueBlack, .whiteBlack:
                return Color(red: 0.0, green: 0.0, blue: 0.0)
            case .red, .blackRed, .blueRed:
                return Color(red: 0.78, green: 0.14, blue: 0.04)
            case .green, .redGreen, .blackGreen:
                return Color(red: 0.19, green: 0.66, blue: 0.20)
            }
        }
    }
}
