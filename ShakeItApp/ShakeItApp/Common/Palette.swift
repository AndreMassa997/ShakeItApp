//
//  Palette.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//
import UIKit

protocol Palette {
    var paletteName: String { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var secondaryColor: UIColor { get }
    var mainBackgroundColor: UIColor { get }
    var mainColor: UIColor { get }
    var mainLabelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var blackLabelColor: UIColor { get }
}

//Common color for both palette
extension Palette {
    var mainColor: UIColor {
        #colorLiteral(red: 0.9921568627, green: 0.9764705882, blue: 0.9019607843, alpha: 1) //#FDF9E6
    }
    
    var secondaryColor: UIColor {
        #colorLiteral(red: 1, green: 0.8, blue: 0.3607843137, alpha: 1) //#FFCC5C
    }
    
    var mainLabelColor: UIColor {
        #colorLiteral(red: 1, green: 0.4352941176, blue: 0.4117647059, alpha: 1) //#FF6F69
    }
    
    var blackLabelColor: UIColor {
        .black
    }
}

struct LightPalette: Palette{
    let paletteName: String = "light"
    
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
    let paletteName: String = "dark"
    
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
