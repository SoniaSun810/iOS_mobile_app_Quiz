//
//  DrawView.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/22.
//

import Foundation
import UIKit

class DrawView : UIView, UIEditMenuInteractionDelegate {
    
    var currentLine : Line?
    var finishedLines = [Line]()
    var selectedLineIndex : Int? {
        didSet {
            if self.selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    var editMenuInteraction : UIEditMenuInteraction!
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines{
            stroke(line)
        }
        currentLineColor.setStroke()
        if let line = currentLine {
            stroke(line)
        }
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("init")
        // Ad the edit menu interaction
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTapRecognizer)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: <#T##Selector?#>)
        addGestureRecognizer(longPressRecognizer)
    }
    
    // Detecting taps with UITapGestureRecognizer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    @objc func doubleTap(_ gestureRecognizer : UIGestureRecognizer) {
        print("recognized a double tap")
        self.selectedLineIndex = nil
        currentLine = nil
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer : UIGestureRecognizer) {
        print("recognized a tap")
        let point = gestureRecognizer.location(in: self)
        self.selectedLineIndex = self.indexOfLine(at: point)
//        // Grab the menu controller
//        self.editMenuInteraction = UIEditMenuInteraction(delegate: self)
//        self.addInteraction(editMenuInteraction!)
//        let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: point)
//        if let interaction = editMenuInteraction {
//               // Present the edit menu interaction.
//               interaction.presentEditMenu(with: configuration)
//           }
        
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            becomeFirstResponder()
            let deleteItem = UIMenuItem(title: "delete", action: #selector(self.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            // Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()
    }
    
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("recognized a long press")
        if gestureRecognizer.state == .began{
            let point = gestureRecognizer.location(in: self)
        }
        if gestureRecognizer.state == .ended{
            penColorMenu(at: point)
        }
        setNeedsDisplay()
    }
    
    
    func penColorMenu(at point: CGPoint) {
        let menu = UIMenuController.shared
        becomeFirstResponder()
        let deleteItem1 = UIMenuItem(title: "red", action: #selector(self.changePenColor(_:)))
        let deleteItem2 = UIMenuItem(title: "yellow", action: #selector(self.changePenColor(_:)))
        let deleteItem3 = UIMenuItem(title: "blue", action: #selector(self.changePenColor(_:)))
        let deleteItem4 = UIMenuItem(title: "green", action: #selector(self.changePenColor(_:)) )
        menu.menuItems = [deleteItem1, deleteItem2, deleteItem3, deleteItem4]
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        setNeedsDisplay()
    }
    
    @objc func changePenColor(_ sender : UIMenuController) {
        
    }
                                     
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index,line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), through: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    @objc func deleteLine(_ sender : UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            self.selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch began")
//        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine = Line(begin:location, end:location)
        setNeedsDisplay()
//        print(self.location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
        print("touch ended")
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            finishedLines.append(line)
        }
        currentLine = nil
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        currentLine = nil
        setNeedsDisplay()
        
        super.touchesCancelled(touches, with: event)
    }
    
    
}
