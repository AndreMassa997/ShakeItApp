//
//  Palette.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//
import UIKit

protocol Palette{
    var paletteName: String { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var secondaryColor: UIColor { get }
    var mainBackgroundColor: UIColor { get }
    var mainColor: UIColor { get }
    var mainLabelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
}

//Common color for both palette
extension Palette {
    var secondaryColor: UIColor {
        #colorLiteral(red: 1, green: 0.8317337036, blue: 0.4332731962, alpha: 1) //#FFCC5C
    }
    
    var mainColor: UIColor {
        #colorLiteral(red: 1, green: 0.9419094324, blue: 0.732694149, alpha: 1) //#FFEEAD
    }
    
    var mainLabelColor: UIColor {
        #colorLiteral(red: 1, green: 0.4352941176, blue: 0.4117647059, alpha: 1) //#FF6F69
    }
}

struct LightPalette: Palette{
    var paletteName: String {
        "light"
    }
    
    var statusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    var mainBackgroundColor: UIColor {
        .white
    }
    
    var secondaryLabelColor: UIColor {
        .black
    }
}

struct DarkPalette: Palette{
    var paletteName: String {
        "dark"
    }
    
    var statusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
  
    var mainBackgroundColor: UIColor {
        .black
    }
    
    var secondaryLabelColor: UIColor {
        .white
    }
}
