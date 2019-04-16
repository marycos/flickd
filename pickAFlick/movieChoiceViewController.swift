//
//  movieChoiceViewController.swift
//  pickAFlick
//
//  Created by Mary Cosentini on 4/15/19.
//  Copyright © 2019 Cosentini Mary. All rights reserved.
//

import UIKit

class movieChoiceViewController: UIViewController{
    
    let vc = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "#274060")
        view.addSubview(movieLabel)
        view.addSubview(descriptionLabel)
        print(movieLabel)
        print(descriptionLabel)
    }
    
    lazy var movieLabel:UILabel! = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        view.textColor = hexStringToUIColor(hex: "#9C7178")
        view.center = CGPoint(x: 200, y: 200)
        view.textAlignment = .center
        return view
    }()
        
    lazy var descriptionLabel:UILabel! = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        view.textColor = hexStringToUIColor(hex: "#9C7178")
        view.center = CGPoint(x: 200, y: 400)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
