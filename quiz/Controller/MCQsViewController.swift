//
//  File.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/15.
//

import UIKit
import SnapKit

class MCQsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Items.sharedInstance.MChoices[idx].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Items.sharedInstance.MChoices[idx][row]
    }
    
    
    
    
    @IBOutlet weak var pickerChoices: UIPickerView!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var idx = 0
    var userAnswer: String = ""
    var reset = false
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        let row = pickerChoices.selectedRow(inComponent: 0)
        checkAnswer(userAnswer: Items.sharedInstance.MChoices[idx][row])
        submitButton.isHidden = true
    }
    
    
    func checkAnswer(userAnswer : String)
    {
        let res : Bool
        if nextQuestionButton.isHidden == true{
            res = (Items.sharedInstance.MCAnwers[Items.sharedInstance.MCQuestions.count - 1] == userAnswer)
        } else {
            res = (Items.sharedInstance.MCAnwers[idx] == userAnswer)
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
    
    
//    nextQuestionButton: if no more question, nextQuestionButtonn is hidden
    @IBAction func nextButton(_ sender: UIButton) {
        if idx < Items.sharedInstance.MCQuestions.count - 1 {
            idx += 1
            pickerChoices.reloadAllComponents()
            questionLabel.text = Items.sharedInstance.MCQuestions[idx]
            answerLabel.text = ""
            submitButton.isHidden = false
        } else {
            idx = 0
            reset = true
            nextQuestionButton.isHidden = true
        }
    }
    
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        label.text = "Exploring SnapKit"
        label.textColor = .white
        return label
    }()
    
    
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        label.text = ""
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerChoices.delegate = self
        pickerChoices.dataSource = self
        
        self.view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(150)
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        
        questionLabel.text = Items.sharedInstance.MCQuestions[idx]
        questionLabel.numberOfLines = 0
        
        self.view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(65)
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        answerLabel.text = ""
        nextQuestionButton.isHidden = false
        submitButton.isHidden = false
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.parent?.navigationItem.title = nil
        
        if reset || Items.sharedInstance.editMode{
            viewDidLoad()
            Items.sharedInstance.score = 0
            Items.sharedInstance.wrong = 0
            reset = false
            Items.sharedInstance.editMode = false
        }
     }
    }
    
