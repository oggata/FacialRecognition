//
//  ViewController.swift
//  FacialRecognition
//
//  Created by Fumitoshi Ogata on 2014/06/30.
//  Copyright (c) 2014年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    @IBOutlet var imageView : UIImageView!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ciImage  = CIImage(CGImage:imageView.image!.CGImage)
        var ciDetector = CIDetector(ofType:CIDetectorTypeFace
            ,context:nil
            ,options:[
                CIDetectorAccuracy:CIDetectorAccuracyHigh,
                CIDetectorSmile:true
            ]
        )
        var features = ciDetector.featuresInImage(ciImage)
        
        UIGraphicsBeginImageContext(imageView.image!.size)
        imageView.image!.drawInRect(CGRectMake(0,0,imageView.image!.size.width,imageView.image!.size.height))
        
        for feature in features{
            
            //context
            var drawCtxt = UIGraphicsGetCurrentContext()
            
            //face
            var faceRect = (feature as CIFaceFeature).bounds
            faceRect.origin.y = imageView.image!.size.height - faceRect.origin.y - faceRect.size.height
            CGContextSetStrokeColorWithColor(drawCtxt, UIColor.redColor().CGColor)
            CGContextStrokeRect(drawCtxt,faceRect)
            
            //mouse
            if((feature.hasMouthPosition) != nil){
                var mouseRectY = imageView.image!.size.height - feature.mouthPosition.y
                var mouseRect  = CGRectMake(feature.mouthPosition.x - 5,mouseRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt,UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,mouseRect)
            }

            //hige
            var higeImg      = UIImage(named:"hige_100.png")
            var mouseRectY = imageView.image!.size.height - feature.mouthPosition.y
            //ヒゲの横幅は顔の4/5程度
            var higeWidth  = faceRect.size.width * 4/5
            var higeHeight = higeWidth * 0.3 // 元画像が100:30なのでWidthの30%が縦幅
            var higeRect  = CGRectMake(feature.mouthPosition.x - higeWidth/2,mouseRectY - higeHeight/2,higeWidth,higeHeight)
            CGContextDrawImage(drawCtxt,higeRect,higeImg!.CGImage)

            //leftEye
            if((feature.hasLeftEyePosition) != nil){
                var leftEyeRectY = imageView.image!.size.height - feature.leftEyePosition.y
                var leftEyeRect  = CGRectMake(feature.leftEyePosition.x - 5,leftEyeRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt, UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,leftEyeRect)
            }
            
            //rightEye
            if((feature.hasRightEyePosition) != nil){
                var rightEyeRectY = imageView.image!.size.height - feature.rightEyePosition.y
                var rightEyeRect  = CGRectMake(feature.rightEyePosition.x - 5,rightEyeRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt, UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,rightEyeRect)
            }
        }
        var drawedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = drawedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

