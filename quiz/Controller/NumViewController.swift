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
        }
        quizProgress.progress = getProgress()
        questionLabel.text = Items.sharedInstance.completionQuestions[0]
        
        self.view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-300)
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        answerLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if idx == 0 {
            viewDidLoad()
            Items.sharedInstance.score = 0
            Items.sharedInstance.wrong = 0
        }
    }
    
    
    
    var userAnswer: String = ""
    var idx = 0
    
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
            res = (Items.sharedInstance.textAnswers[Items.sharedInstance.completionQuestions.count - 1] == userAnswer)
        } else {
            res = (Items.sharedInstance.textAnswers[idx] == userAnswer)
        }
        
        if res {
            Items.sharedInstance.score += 1
            answerLabel.text = "CORRECT!"
            answerLabel.textColor = UIColor.green
            answerLabel.font = UIFont(name: "GillSans-Bold", size: CGFloat(40))
        } else {
            Items.sharedInstance.wrong += 1
            answerLabel.text = "ICORRECT!"
            answerLabel.textColor = UIColor.red
            answerLabel.font = UIFont(name: "GillSans-Bold", size: CGFloat(40))
        }
    }
    
    
    func getProgress() -> Float {
        let progress = Float(idx + 1) / Float(Items.sharedInstance.completionQuestions.count)
        return progress
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        if idx < Items.sharedInstance.completionQuestions.count - 1 {
            idx += 1
            questionLabel.text = Items.sharedInstance.completionQuestions[idx]
            quizProgress.progress = getProgress()
            submitButton.isHidden = false
        } else {
            idx = 0
            nextButton.isHidden = true
        }
        answerLabel.text = ""
    }
}

