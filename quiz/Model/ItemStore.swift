//
//  Items.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/17.
//

import UIKit

class Item {
    var question : String
    var answer : String
    let dateCreated : Date
    
    
    // Adding a designated initializer
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.dateCreated = Date()
    }
}

 
class ItemStore {
    var allItems = [Item] ()
}




