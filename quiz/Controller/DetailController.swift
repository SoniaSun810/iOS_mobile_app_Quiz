//
//  DetailController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/18.
//

import Foundation
import UIKit

class DetailController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
//        var tab = UITapGestureRecognizer(target: self, action: #selector(close))
//        self.view.addGestureRecognizer(tab)
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target:self, action: #selector(self.randomBackground)))
    }
    
    @objc func randomBackground() {
        self.view.backgroundColor = UIColor.init(
            red: CGFloat(arc4random()%255)/255.0,
            green: CGFloat(arc4random()%255)/255.0,
            blue: CGFloat(arc4random()%255)/255.0,
            alpha: 1
        )
    }
    
    
    }
    
//    func close() {
//        self.dismiss(animated: true)
//    }


