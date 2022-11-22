//
//  File.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/16.
//

import Foundation

class Items {

// Score data
    var score: Int = 0
    var wrong: Int = 0
// Edit mode turn on & turn off
    var editMode = false
    var addMode = false
    
    
    var items : [Item] = []

    static let sharedInstance = {
        let instance = Items()
        
        instance.items.append(Item(question:"What is 2 * 2.1 ?", answer:"4.2"))
        instance.items.append(Item(question:"What is 14 - 7 ?", answer:"7"))
        instance.items.append(Item(question:"What is the 18 / 6 ?", answer:"3"))
        instance.items.append(Item(question:"What is 2 * 2.1 ?", answer:"4.2"))
        instance.items.append(Item(question:"What is 14 - 7 ?", answer:"7"))
        instance.items.append(Item(question:"What is the 18 / 6 ?", answer:"3"))

        return instance
    }()
    
    private init() {}
    
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
    
}


