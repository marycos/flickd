//
//  ViewController.swift
//  pickAFlick
//
//  Created by Mary Cosentini on 4/11/19.
//  Copyright © 2019 Cosentini Mary. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import TMDBSwift

class ViewController: UIViewController {
    
    var html:String? = nil
    var movies:[Movie] = []
    var movieName:String = ""
    var movieDesc:String = ""
    var movieYear:String = ""
    
    override func viewDidLoad() {
        startLanding()

    }
    
    lazy var instructionLabel:UILabel! = {
       let view = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
       view.center = CGPoint(x: 175, y: 175)
       view.text = "Enter the URL of the Letterboxd list:"
       view.textAlignment = .center
       view.textColor = hexStringToUIColor(hex: "#9C7178")
       return view
    }()
    
    lazy var userInput:UITextField! = {
       let view = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.center = CGPoint(x: 185, y: 300)
        view.borderStyle = UITextField.BorderStyle.roundedRect
        view.autocorrectionType = UITextAutocorrectionType.no
        view.keyboardType = UIKeyboardType.default
        view.returnKeyType = UIReturnKeyType.done
        view.clearButtonMode = UITextField.ViewMode.whileEditing
        view.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        view.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return view
    }()

    lazy var enterButton:UIButton! = {
        let view = UIButton(frame: CGRect(x: 140, y: 425, width: 100, height: 50))
        view.backgroundColor = hexStringToUIColor(hex: "#9C7178")
        view.setTitle("Submit", for: .normal)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    @objc func buttonAction(sender: UIButton!) {
        let textFieldAsString:String = userInput.text ?? "error"
        print(textFieldAsString)
        scrapeLetterboxd(textField: textFieldAsString)
    }
    
    func moveToSecondViewController() {
        let vc = movieChoiceViewController()
        vc.movieLabel.text = movieName
        vc.descriptionLabel.text = movieDesc
        self.navigationController?.pushViewController(vc, animated: true)   
    }
    
    func scrapeLetterboxd(textField:String){
        Alamofire.request(textField).responseString{ response in
            self.html = response.result.value
            self.parseHTML(html: response.result.value!)
            self.moveToSecondViewController()
        }
    }
    
    
    func parseHTML(html:String){
        do {
            let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            var i = 0
            for _ in doc.xpath("//div[@class='poster film-poster really-lazy-load']//@alt"){
                i+=1
            }
            let number = Int.random(in: 0 ... (i - 1))
            self.movieName = doc.xpath("//div[@class='poster film-poster really-lazy-load']//@alt")[number].text ?? "nil"
            SearchMDB.movie(query: self.movieName, language: "en", page: 1, includeAdult: true, year: nil, primaryReleaseYear: nil){
                data, movies in self.movieDesc = movies?[0].overview ?? "nil"
            }
        }catch {
            print("error")
        }
    }
    
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
    
    func startLanding(){
        TMDBConfig.apikey = "81724aee59b3422b5b90e6801e0b2eac"
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "#274060")
        view.addSubview(instructionLabel)
        view.addSubview(userInput)
        view.addSubview(enterButton)
    }
  
    
}






