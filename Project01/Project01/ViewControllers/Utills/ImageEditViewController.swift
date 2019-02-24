
//
//  ImageEditViewController.swift
//  Project01
//
//  Created by 박종현 on 24/02/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ImageEditViewController: UIViewController {

    var delegate:ImageEditDelegate!
    
    var image:UIImage!
    @IBOutlet weak var imageMaxSizeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var cropViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cropViewWidth: NSLayoutConstraint!
    
    var maxWidth:CGFloat = 0;
    var maxHeight:CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutIfNeeded()
        self.checkRatio(image: self.image)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("self.cropView.frame : \(self.cropView.frame)")
        print("imageView.frame : \(imageView.frame)")
        print("image.size : \(image.size)")
        
        // x 비율
        let x = image.size.width/imageView.frame.width * (self.cropView.frame.origin.x - imageView.frame.origin.x)
        // y 비율
        let y = image.size.height/imageView.frame.height * (self.cropView.frame.origin.y - imageView.frame.origin.y)
        // width 비율
        let width = image.size.width/imageView.frame.width * self.cropView.frame.width
        // height 비율
        let height = image.size.height/imageView.frame.height * self.cropView.frame.height
        
        let rect = CGRect.init(x: x, y: y, width: width, height: height)
        print(rect)
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        self.setProtocolImage(image: croppedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    // height에 맞춤
    func adjustByHeight(image:UIImage, ratio:CGFloat, viewWidth:CGFloat, viewHeight:CGFloat) {
        print("height에 맞춤")
        
        // 보정된 width, height
        let reviseHeight = viewHeight
        let reviseWidth = viewWidth * ratio
        
        
        imageViewHeight.constant = reviseHeight
        imageViewWidth.constant = reviseWidth
        self.maxWidth = reviseWidth
        self.maxHeight = reviseHeight
        self.imageView.image = image
        print("reviseHeight : \(reviseHeight)")
        print("reviseWidth : \(reviseWidth)")
        view.layoutIfNeeded()
        
        self.setCropView(width: reviseWidth, height: reviseWidth)
    }
    
    // width에 맞춤
    func adjustByWidth(image:UIImage, ratio:CGFloat, viewWidth:CGFloat, viewHeight:CGFloat) {
        print("width에 맞춤")
        
        // 보정된 width, height
        let reviseWidth = viewWidth
        let reviseHeight = reviseWidth / ratio
        
        imageViewHeight.constant = reviseHeight
        imageViewWidth.constant = reviseWidth
        self.maxWidth = reviseWidth
        self.maxHeight = reviseHeight
        self.imageView.image = image
        print("reviseHeight : \(reviseHeight)")
        print("reviseWidth : \(reviseWidth)")
        view.layoutIfNeeded()
        self.setCropView(width: reviseHeight, height: reviseHeight)
    }
    
    // 비율 확인
    func checkRatio(image:UIImage)  {
        print("self.imageMaxSizeView : \(self.imageMaxSizeView.frame)")
        let viewWidth = self.imageMaxSizeView.frame.width
        let viewHeight = self.imageMaxSizeView.frame.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        // 이미지 비율 = 이미지 가로 / 이미지 세로
        let imageRatio = imageWidth / imageHeight
        
        // 보정된 width, height
        let reviseWidth = viewWidth
        let reviseHeight = reviseWidth / imageRatio
        
        // 만약 height비율이 더 크면 height로 맞춘다.
        if reviseHeight > viewHeight {
            self.adjustByHeight(image: self.image, ratio: imageRatio, viewWidth: viewWidth, viewHeight: viewHeight)
        }else {
            self.adjustByWidth(image: self.image, ratio: imageRatio, viewWidth: viewWidth, viewHeight: viewHeight)
        }
    }
    
    func setCropView(width:CGFloat, height:CGFloat) {
        self.cropViewWidth.constant = width
        self.cropViewHeight.constant = height
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(_:)))
        // let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGesture(_:)))
        self.cropView.addGestureRecognizer(panGesture)
        // self.cropView.addGestureRecognizer(pinchGesture)
        
        view.layoutIfNeeded()
    }
    
    @objc func panGesture(_ pan: UIPanGestureRecognizer) {
        print("Being Dragged")
        
        let minX = self.imageView.frame.origin.x
        let maxX = self.imageView.frame.origin.x + self.imageView.frame.width - self.cropView.frame.width
        let minY = self.imageView.frame.origin.y
        let maxY = self.imageView.frame.origin.y + self.imageView.frame.height - self.cropView.frame.height
        print("minX : \(minX)")
        print("maxX : \(maxX)")
        print("minY : \(minY)")
        print("maxY : \(maxY)")
        
        let transition = pan.translation(in: self.cropView)
        var changedX = self.cropView.frame.origin.x + transition.x
        print("changedX : \(changedX)")
        if changedX < minX {
            changedX = minX
        }else if changedX > maxX {
            changedX = maxX
        }
        
        var changedY = self.cropView.frame.origin.y + transition.y
        print("changedY : \(changedY)")
        if changedY < minY {
            changedY = minY
        }else if changedY > maxY {
            changedY = maxY
        }
        
        self.cropView.frame = CGRect.init(origin: CGPoint(x: changedX, y: changedY), size: self.cropView.frame.size)
        
        pan.setTranslation(CGPoint.zero, in: self.cropView)
        
        
    }
    @objc func pinchGesture(_ gesture: UIPinchGestureRecognizer){
        print("Being Scaled : \(gesture.scale)")
        let updateWidth = self.cropView.frame.width * gesture.scale
        let updateHeight = self.cropView.frame.height * gesture.scale
      
        self.cropView.transform = self.cropView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        
        gesture.scale = 1.0
    
        print("self.cropView.frame : \(self.cropView.frame)")
    }
    
}

extension ImageEditViewController: ImageEditDelegate {
    func setProtocolImage(image: UIImage) {
        delegate.setProtocolImage(image: image)
    }
}
