//
//  DrawViewController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/22.
//

import Foundation
import UIKit
import SnapKit

class DrawViewController : UIViewController {
    
    
    lazy var drawView: DrawView = {
        let view = DrawView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.drawView)
        self.drawView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
    }
    
}
