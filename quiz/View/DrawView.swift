//
//  DrawView.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/22.
//

import Foundation
import UIKit

class DrawView : UIView, UIEditMenuInteractionDelegate, UIGestureRecognizerDelegate{
    
    var currentLine : Line?
    var finishedLines = [Line]()
    var penColorNow = UIColor.black
    var imageToSave : UIImage!
    var selectedLineIndex : Int?
    var moveRecognizer : UIPanGestureRecognizer!
    
    var editMenuInteraction : UIEditMenuInteraction!
    
    
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
        for line in finishedLines{
            let strokeColor = line.color
            strokeColor.setStroke()
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
        
        // Grab the menu controller
        self.editMenuInteraction = UIEditMenuInteraction(delegate: self)
        self.addInteraction(editMenuInteraction!)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTapRecognizer)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        self.addGestureRecognizer(longPressRecognizer)
        
        self.moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.moveLine(_:)))
        self.moveRecognizer.delegate = self
        self.moveRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(moveRecognizer)
    }
    
    // Detecting taps with UITapGestureRecognizer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.moveRecognizer {
            let point = gestureRecognizer.location(in: self)
            self.selectedLineIndex = self.indexOfLine(at: point)
            return selectedLineIndex != nil
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @objc func moveLine(_ gestureRecognizer : UIPanGestureRecognizer) {
        print("recognized a pan")
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                setNeedsDisplay()
            } else {
                return
            }
        }
    }
    
    @objc func doubleTap(_ gestureRecognizer : UIGestureRecognizer) {
        print("recognized a double tap")
        
        let alertController = UIAlertController(title: nil, message: "Are you sure to Delete All Lines on canvas?", preferredStyle: .alert)
        alertController.modalPresentationStyle = .popover
        
        let yesAction = UIAlertAction(title: "Yes", style: .default){
            _ in
            self.deleteAllLines()
        }
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        
        self.parentViewController?.present(alertController, animated: true)
    }
    
    func deleteAllLines() {
        self.selectedLineIndex = nil
        currentLine = nil
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer : UIGestureRecognizer) {
        print("recognized a tap")
        let point = gestureRecognizer.location(in: self)
        self.selectedLineIndex = self.indexOfLine(at: point)
        if selectedLineIndex != nil {
            becomeFirstResponder()
            let configuration = UIEditMenuConfiguration(identifier: "editLine", sourcePoint: point)
            if let interaction = editMenuInteraction {
                // Present the edit menu interaction.
                interaction.presentEditMenu(with: configuration)
            }
        }
    }
    
    func editMenuInteraction(
        _ interaction: UIEditMenuInteraction,
        menuFor configuration: UIEditMenuConfiguration,
        suggestedActions: [UIMenuElement]
    ) -> UIMenu? {

        let deleteLine = UIKeyCommand(title: "Delete",
                                       action: #selector(self.deleteLine),
                                       input: "n",
                                       modifierFlags: .command)
        let changeBlue = UIKeyCommand(title: "Blue",
                                      action: #selector(self.changeLineColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let changePurple = UIKeyCommand(title: "Purple",
                                      action: #selector(self.changeLineColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let changeYellow = UIKeyCommand(title: "Yellow",
                                      action: #selector(self.changeLineColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let changeOrange = UIKeyCommand(title: "Orange",
                                      action: #selector(self.changeLineColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let penBlue = UIKeyCommand(title: "Blue",
                                      action: #selector(self.changePenColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let penPurple = UIKeyCommand(title: "Purple",
                                      action: #selector(self.changePenColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let penYellow = UIKeyCommand(title: "Yellow",
                                      action: #selector(self.changePenColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)
        let penOrange = UIKeyCommand(title: "Orange",
                                      action: #selector(self.changePenColor(_:)),
                                        input: "o",
                                        modifierFlags: .command)


        // Use the .displayInline option to avoid displaying the menu as a submenu,
        // and to separate it from the other menu elements using a line separator.
        let newMenu1 = UIMenu(title: "", options: .displayInline, children: [deleteLine, changeBlue, changePurple, changeYellow, changeOrange])
        let newMenu2 = UIMenu(title: "", options: .displayInline, children: [penBlue, penPurple, penYellow, penOrange])
        
        if configuration.identifier == AnyHashable("editLine") {
            return newMenu1
        } else if configuration.identifier == AnyHashable("changePenColor") {
            return newMenu2
        }
        return nil
    }
    
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("recognized a long press")
        if gestureRecognizer.state == .ended{
            let point = gestureRecognizer.location(in: self)
            self.selectedLineIndex = self.indexOfLine(at: point)
            if selectedLineIndex != nil {
                deleteLine()
            } else {
                becomeFirstResponder()
                let configuration = UIEditMenuConfiguration(identifier: "changePenColor", sourcePoint: point)
                if let interaction = editMenuInteraction {
                    // Present the edit menu interaction.
                    interaction.presentEditMenu(with: configuration)
                }
            }
        }
        setNeedsDisplay()
    }
    
    @objc func changePenColor(_ sender : UIKeyCommand) {
        var changeColorTo = UIColor.black
        if sender.title == "Blue" {
            changeColorTo = UIColor.blue
        } else if sender.title == "Purple" {
            changeColorTo = UIColor.purple
        } else if sender.title == "Yellow" {
            changeColorTo = UIColor.yellow
        } else {
            changeColorTo = UIColor.orange
        }
        penColorNow = changeColorTo
    }
                                     
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), through: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 25.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    @objc func deleteLine() {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            self.selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func changeLineColor(_ sender : UIKeyCommand) {
        var changeColorTo = UIColor.black
        if sender.title == "Blue" {
            changeColorTo = UIColor.blue
        } else if sender.title == "Purple" {
            changeColorTo = UIColor.purple
        } else if sender.title == "Yellow" {
            changeColorTo = UIColor.yellow
        } else {
            changeColorTo = UIColor.orange
        }
        if let index = selectedLineIndex {
            finishedLines[index].color = changeColorTo
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touch began")
        print(self.moveRecognizer.state)
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine = Line(begin:location, end:location)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touch moved")
        print(self.moveRecognizer.state)
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touch ended")
        print(self.moveRecognizer.state)
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            line.color = penColorNow
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
    
    // MARK: - UIView->UIImage
    func getImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
    let context = UIGraphicsGetCurrentContext()
    self.layer.render(in: context!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    }
    
    @objc func saveImage() {
        imageToSave = getImage()
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
