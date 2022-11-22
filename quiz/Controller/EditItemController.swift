//
//  AddNewItemController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/20.
//

import Foundation
import UIKit

class EditItemController : UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    var item : Item!
    var isEdit = false
    
    //    lazy var imageView: UIImageView = {
    //
    //    }
    
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
    
    
    lazy var imageArea : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "choices")!
        image.contentMode = .scaleAspectFit
        return image
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
        //        var tab = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        
        //        if item == nil {
        //            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
        //        }
        
        self.view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.view).offset(155)
            make.left.equalTo(self.view).offset(25)
        }
        
        self.view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.equalTo(self.view).offset(205)
            make.left.equalTo(self.view).offset(25)
        }
        
        self.view.addSubview(questionText)
        questionText.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.top.equalTo(self.view).offset(150)
            make.left.equalTo(self.view).offset(110)
        }
        
        self.view.addSubview(answerText)
        answerText.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.top.equalTo(self.view).offset(200)
            make.left.equalTo(self.view).offset(110)
        }
        
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(self.view).offset(-50)
        }
        
        if item != nil {
            if let image = ImageStore.shareImageStore.image(forKey: item.itemKey) {
                imageArea.image = image
            }
        }
        
        self.view.addSubview(imageArea)
        imageArea.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.view).offset(-250)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 300, height: 300))
        }
        
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
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(self.choosePhotoSource))
        let drawButton = UIBarButtonItem(title: "Draw", style: .plain, target: self, action: nil)
        let removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(self.removePhoto))
        
        //        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        //
        //        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
        //
       
        let arr: [Any] = [cameraButton, drawButton, removeButton]
        setToolbarItems(arr as? [UIBarButtonItem] ?? [UIBarButtonItem](), animated: true)
        
    }
    
    @objc func choosePhotoSource() {
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
//            imagePicker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Remove a photo
    @objc func removePhoto() {
        if item != nil {
            ImageStore.shareImageStore.deleteImage(forKey: item.itemKey)
            imageArea.image = UIImage(named: "choices")!
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
        imageArea.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // Adaptive Interface
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
//                imageView.image = UIImage(named: const2)
            } else {
                print("Portrait")
//                imageView.image = UIImage(named: const)
            }
        }
    
    
}





