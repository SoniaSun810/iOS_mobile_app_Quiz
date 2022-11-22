//
//  Cell.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/17.
//

import Foundation
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        label.text = "Exploring SnapKit"
        label.textColor = .black
        return label
    }()
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.text = "Exploring SnapKit"
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(questionLabel)
        self.contentView.addSubview(answerLabel)
        
        questionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(7)
            make.left.equalTo(self.contentView).offset(25)
            make.width.lessThanOrEqualTo(self.contentView).offset(-50)
        }
        
        answerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(-7)
            make.left.equalTo(self.contentView).offset(25)
            make.width.lessThanOrEqualTo(self.contentView).offset(-50)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setQuestion(question: String) {
        questionLabel.text = question
    }
    
    public func setAnswer(answer: String) {
        answerLabel.text = answer
    }
    
}
