//
//  File.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/15.
//

import UIKit
import SnapKit

class ScoresViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(Items.sharedInstance.score)
        scoreLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 50)
        scoreLabel.textColor = .gray
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.parent?.navigationItem.title = nil
        
        scoreLabel.text = String(Items.sharedInstance.score)
        
        if Items.sharedInstance.score > Items.sharedInstance.wrong {
            self.view.backgroundColor = UIColor.green
        } else if Items.sharedInstance.score < Items.sharedInstance.wrong{
            self.view.backgroundColor = UIColor.red
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
    }

}


