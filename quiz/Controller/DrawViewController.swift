//
//  DrawViewController.swift
//  quiz
//
//  Created by 孙丰楠 on 2022/11/22.
//

import Foundation
import UIKit
import SnapKit

class DrawViewController : UIViewController,  UINavigationControllerDelegate {
    
    var item : Item!
    
    convenience init(itemDetail : Item?) {
        self.init(nibName:nil, bundle:nil)
        self.item = itemDetail
    }
    
    lazy var drawView: DrawView = {
        let view = DrawView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.finishedLines = item.pictureDraw
        self.view.addSubview(self.drawView)
        self.drawView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveDrawAsImageView))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        item.pictureDraw = drawView.finishedLines
    }
    
    @objc func saveDrawAsImageView() {
        drawView.saveImage()
        ImageStore.shareImageStore.setImage(drawView.imageToSave, forKey: item.itemKey)
    }
}
