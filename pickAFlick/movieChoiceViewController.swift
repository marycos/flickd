//
//  movieChoiceViewController.swift
//  pickAFlick
//
//  Created by Mary Cosentini on 4/15/19.
//  Copyright © 2019 Cosentini Mary. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import TMDBSwift
import Nuke

class movieChoiceViewController: UIViewController{
    
    lazy var retryURL:String = ""
    let vc = ViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "#274060")
        view.addSubview(movieLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(retryButton)
        view.addSubview(poster)
//        print(movieLabel)
//        print(descriptionLabel)
    }
    
    lazy var movieLabel:UILabel! = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.textColor = hexStringToUIColor(hex: "#9C7178")
        view.center = CGPoint(x: 200, y: 100)
        view.textAlignment = .center
        view.font = UIFont(name: view.font.fontName, size: 30)
        return view
    }()
    
    lazy var descriptionLabel:UILabel! = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        view.textColor = hexStringToUIColor(hex: "#9C7178")
        view.center = CGPoint(x: 200, y: 500)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var retryButton:UIButton! = {
        let view = UIButton(frame: CGRect(x: 100, y: 600, width: 200, height: 50))
        view.backgroundColor = hexStringToUIColor(hex: "#9C7178")
        view.setTitle("Pick again", for: .normal)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    lazy var poster:UIImageView! = {
        let view = UIImageView(frame: CGRect(x: 10, y: 10, width: 125, height: 187))
        view.center = CGPoint(x: 200, y: 250)

        return view
    }()
    
    @objc func buttonAction(sender: UIButton!) {
        pickAgain()
    }
    
    func pickAgain(){
        scrapeLetterboxd(textField: retryURL)
    }
    
    func scrapeLetterboxd(textField:String){
        Alamofire.request(textField).responseString{ response in
            self.vc.html = response.result.value
            self.parseHTML(html: response.result.value!)
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
            self.vc.movieName = doc.xpath("//div[@class='poster film-poster really-lazy-load']//@alt")[number].text ?? "nil"
            SearchMDB.movie(query: self.vc.movieName, language: "en", page: 1, includeAdult: true, year: nil, primaryReleaseYear: nil){
                data, movies in self.vc.movieDesc = movies?[0].overview ?? "nil"
                self.movieLabel.text = self.vc.movieName
                self.descriptionLabel.text = self.vc.movieDesc
            }
            SearchMDB.movie(query: self.vc.movieName, language: "en", page: 1, includeAdult: true, year: nil, primaryReleaseYear: nil){
                data, movies in self.vc.movieID = movies?[0].id ?? 0
                //print(self.vc.movieID)
                MovieMDB.images(movieID: self.vc.movieID, language: "en"){
                    data, imgs in
                    if let images = imgs{
                        print(images.posters[0].file_path ?? "nil")
                        //Backdrop & stills might return `nil`
                        // print(images.stills[0].file_path)
                        //print(images.backdrops[0].file_path)
                    }
                self.vc.moveToSecondViewController()
            }
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
    
}


