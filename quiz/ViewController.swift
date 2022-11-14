//
//  ViewController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/14.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
        "What is the radiu of the earth?",
        "What is 14 - 7?",
        "What is the capital of China?",
        "What is the largest animal in the world?"
        
    ]
    
    let answers: [String] = [
        "6738km",
        "7",
        "Beijing",
        "blue whale"
    ]
    
    var currentQuestionIndex : Int = 0
    
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count{
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
           
    }
    
    @IBAction func showAnswer(_ sender: UIButton){
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
        
    }


}

