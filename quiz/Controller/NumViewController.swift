//
//  ViewController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/14.
//

import UIKit

class ViewController:
    UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet weak var quizProgress: UIProgressView!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var ImageArea: UIImageView!
    
    var imageStore : ImageStore!
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        label.text = ""
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nextButton.isHidden == true {
            nextButton.isHidden = false
            submitButton.isHidden = false
        }
        submitButton.isHidden = false
        nextButton.isHidden = false
        idx = 0
        quizProgress.progress = getProgress()
        questionLabel.text = Items.sharedInstance.items[0].question
        
        if let image = ImageStore.shareImageStore.image(forKey: Items.sharedInstance.items[0].itemKey) {
            ImageArea.image = image
            print(ImageArea.image)
        } else {
            ImageArea.image = nil
        }
        self.view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(65)
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        answerLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.parent?.navigationItem.title = nil
        
        if reset || Items.sharedInstance.editMode || Items.sharedInstance.addMode {
            viewDidLoad()
            Items.sharedInstance.score = 0
            Items.sharedInstance.wrong = 0
            reset = false
            Items.sharedInstance.editMode = false
            Items.sharedInstance.addMode = false
        }
    }
    
    
    
    var userAnswer: String = ""
    var idx = 0
    var reset = false
    
    @IBAction func submitButton(_ sender: UIButton) {
        if let text = answerText.text, !text.isEmpty {
            userAnswer = text
        } else {
                userAnswer = "???"
            }
        answerText.text = ""
        checkAnswer(userAnswer: userAnswer)
        submitButton.isHidden = true

    }
    
// dismiss keyboard by clicking outside textbook
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func checkAnswer(userAnswer : String)
    {
        let res : Bool
        if nextButton.isHidden == true{
            res = (Items.sharedInstance.items[Items.sharedInstance.items.count - 1].answer == userAnswer)
        } else {
            res = (Items.sharedInstance.items[idx].answer == userAnswer)
        }
        
        if res {
            Items.sharedInstance.score += 1
            answerLabel.text = "CORRECT!"
            answerLabel.textColor = UIColor.green
            answerLabel.font = UIFont(name: "GillSans-Bold", size: CGFloat(40))
        } else {
            Items.sharedInstance.wrong += 1
            answerLabel.text = "INCORRECT!"
            answerLabel.textColor = UIColor.red
            answerLabel.font = UIFont(name: "GillSans-Bold", size: CGFloat(40))
        }
    }
    
    
    func getProgress() -> Float {
        let progress = Float(idx + 1) / Float(Items.sharedInstance.items.count)
        return progress
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        if idx < Items.sharedInstance.items.count - 1 {
            idx += 1
            questionLabel.text = Items.sharedInstance.items[idx].question
            if let image = ImageStore.shareImageStore.image(forKey: Items.sharedInstance.items[idx].itemKey){
                ImageArea.image = image
            } else {
                ImageArea.image = nil
            }
            quizProgress.progress = getProgress()
            submitButton.isHidden = false
        } else {
            idx = 0
            nextButton.isHidden = true
            reset = true
        }
        answerLabel.text = ""
    }
}

 
