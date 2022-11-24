//
//  AddNewItemController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/20.
//

import Foundation
import UIKit
import SnapKit

class EditItemController : UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    var item : Item!
    var isEdit = false
    var imageConstraintX : ConstraintMakerEditable!
    var imageConstraintY : ConstraintMakerEditable!
    var dateBottom: ConstraintMakerEditable!
    var questionLabelLeft: ConstraintMakerEditable!
    var answerLabelLeft: ConstraintMakerEditable!
    var questionTextLeft: ConstraintMakerEditable!
    var answerTextLeft: ConstraintMakerEditable!
   
   
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.textColor = .gray
        label.text = "question"
        return label
    }()
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.textColor = .gray
        label.text = "answer"
        return label
    }()
    
    lazy var questionText: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        text.placeholder = "Insert here"
        text.backgroundColor = UIColor.white
        text.textColor = .black
        return text
    }()
    
    
    lazy var answerText: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        text.placeholder = "Insert here"
        text.backgroundColor = UIColor.white
        text.textColor = .black
        return text
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.text = "Set a New Question"
        label.textColor = .gray
        return label
    }()
    
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "choices")!
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    convenience init(isEditMode : Bool, itemDetail : Item?) {
        self.init(nibName:nil, bundle:nil)
        self.isEdit = isEditMode
        self.item = itemDetail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemYellow
   
        self.view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.view).offset(155)
        }
        
        self.view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.view).offset(205)
        }
        
        self.view.addSubview(questionText)
        questionText.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.top.equalTo(self.view).offset(150)
        }
        
        self.view.addSubview(answerText)
        answerText.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.top.equalTo(self.view).offset(200)
        }
        
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        
        if item != nil {
            if let image = ImageStore.shareImageStore.image(forKey: item.itemKey) {
                imageView.image = image
            }
        }
        
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) in
            make.size.equalTo(CGSize(width: 250, height: 250))
        }
        
        self.makeConstraint()
        self.questionText.delegate = self
        self.answerText.delegate = self
    }
    
    
    // Editing Mode: Reordering and deleting
    @objc func saveChange() {
        if item == nil {
            let newItem = Item(question:questionText.text!, answer: answerText.text!)
            Items.sharedInstance.items.append(newItem)
        } else {
            item.question = questionText.text!
            item.answer = answerText.text!
            item.dateCreated = Date()
        }
        self.questionText.isUserInteractionEnabled = false
        self.answerText.isUserInteractionEnabled = false
        Items.sharedInstance.addMode = true
    }
    
    // Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveChange))
        self.setUpToolBar()
        
        if item != nil {
            questionText.text = item.question
            answerText.text = item.answer
            dateLabel.text = dateFormatter.string(from: item.dateCreated)
            if let image = ImageStore.shareImageStore.image(forKey: item.itemKey) {
                imageView.image = image
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Set up tool bar
    func setUpToolBar(){
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = UIColor.black
        navigationController?.toolbar.tintColor = UIColor.white
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(self.choosePhoto))
        let drawButton = UIBarButtonItem(title: "Draw", style: .plain, target: self, action: #selector(self.drawPhoto))
        let removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(self.removePhoto))
        let arr: [Any] = [cameraButton, drawButton, removeButton]
        setToolbarItems(arr as? [UIBarButtonItem] ?? [UIBarButtonItem](), animated: true)
        
    }
    
    @objc func choosePhoto() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) {
                _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){
            _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Draw a picture
    @objc func drawPhoto() {
        var drawController : DrawViewController!
        if item != nil {
            drawController = DrawViewController(itemDetail: item)
        } else {
            let newItem = Items.sharedInstance.items[Items.sharedInstance.items.count - 1]
            drawController = DrawViewController(itemDetail: newItem)
            item = newItem
        }
        self.navigationController?.pushViewController(drawController, animated: true)
    }
    
    // Remove a photo
    @objc func removePhoto() {
        if item != nil {
            ImageStore.shareImageStore.deleteImage(forKey: item.itemKey)
            imageView.image = UIImage(named: "choices")!
        }
    }

    
    // Adding an image picker controller creation method
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    // Accessing the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        // Store the image in the ImageStore for the item's key
        if item != nil {
            ImageStore.shareImageStore.setImage(image, forKey: item.itemKey)
        } else {
            let newItem = Items.sharedInstance.items[Items.sharedInstance.items.count - 1]
            ImageStore.shareImageStore.setImage(image, forKey: newItem.itemKey)
        }
//        print(ImageStore.shareImageStore.image(forKey: item.itemKey))
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // Adaptive Interface
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.makeConstraint()
        print("view will transition")
        }
    
    func makeConstraint() {
        self.imageConstraintX?.constraint.deactivate()
        self.imageConstraintY?.constraint.deactivate()
        self.dateBottom?.constraint.deactivate()
        self.questionLabelLeft?.constraint.deactivate()
        self.answerLabelLeft?.constraint.deactivate()
        self.questionTextLeft?.constraint.deactivate()
        self.answerTextLeft?.constraint.deactivate()
        
        if UIDevice.current.orientation.isPortrait ||
            (UIDevice.current.orientation == UIDeviceOrientation.unknown &&
            self.view.frame.size.width < self.view.frame.size.height) {
            imageView.snp.makeConstraints{ (make) in
                self.imageConstraintX = make.centerX.equalTo(self.view)
                self.imageConstraintY = make.centerY.equalTo(self.view).offset(80)
            }
            dateLabel.snp.makeConstraints { make in
                self.dateBottom = make.bottom.equalTo(self.view).offset(-80)
            }
            questionLabel.snp.makeConstraints { make in
                self.questionLabelLeft = make.left.equalTo(self.view).offset(25)
            }
            answerLabel.snp.makeConstraints { make in
                self.answerLabelLeft = make.left.equalTo(self.view).offset(25)
            }
            questionText.snp.makeConstraints { make in
                self.questionTextLeft = make.left.equalTo(self.view).offset(110)
            }
            answerText.snp.makeConstraints { make in
                self.answerTextLeft = make.left.equalTo(self.view).offset(110)
            }
        } else {
            imageView.snp.makeConstraints{ (make) in
                self.imageConstraintX = make.centerX.equalTo(self.view).offset(180)
                self.imageConstraintY = make.centerY.equalTo(self.view).offset(-20)
            }
            dateLabel.snp.makeConstraints { make in
                self.dateBottom = make.bottom.equalTo(self.view).offset(-35)
            }
            questionLabel.snp.makeConstraints { make in
                self.questionLabelLeft = make.left.equalTo(self.view).offset(60)
            }
            answerLabel.snp.makeConstraints { make in
                self.answerLabelLeft = make.left.equalTo(self.view).offset(60)
            }
            questionText.snp.makeConstraints { make in
                self.questionTextLeft = make.left.equalTo(self.view).offset(140)
            }
            answerText.snp.makeConstraints { make in
                self.answerTextLeft = make.left.equalTo(self.view).offset(140)
            }
        }
    }
    
}





