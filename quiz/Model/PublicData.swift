//
//  File.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/16.
//

import Foundation

class Items {
    static let sharedInstance = Items()
    
    var score: Int = 0
    
    var wrong: Int = 0
    
    var MCQuestions: [String] = [
        "Which of the following is not a planet?",
        "Which of the following is not a fruit?",
        "What of the following is not a mammal"
    ]
    
    
    var MChoices: [Array] = [
    ["Earth", "Sun", "Mars", "Venus"],
    ["Watermelon", "Grape", "Banana", "Lettuce"],
    ["Panda", "Snake", "Cat", "Dog"],
    ]
    
    
    var MCAnwers: [String] = [
        "Sun",
        "Lettuce",
        "Snake"
    ]
    
    var completionQuestions: [String] = [
        "What is 2 * 2.1 ?",
        "What is 14 - 7 ?",
        "What is the 18 / 6 ?",
    ]
    
    
    var textAnswers: [String] = [
        "4.2",
        "7",
        "3",
    ]
 
}
