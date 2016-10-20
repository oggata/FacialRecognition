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
    @IBOutlet var imageReceivedImageView : UIImageView!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ciImage  = CIImage(cgImage:imageReceivedImageView.image!.cgImage!)
        let ciDetector = CIDetector(ofType:CIDetectorTypeFace
            ,context:CIContext()
            ,options:[
                CIDetectorAccuracy:CIDetectorAccuracyHigh,
                CIDetectorSmile:true
            ]
        )
        let features = ciDetector?.features(in: ciImage)
        
        UIGraphicsBeginImageContext(imageReceivedImageView.image!.size)
        imageReceivedImageView.image!.draw(in: CGRect(x:0,y:0,width:imageReceivedImageView.image!.size.width,height:imageReceivedImageView.image!.size.height))
        
        for feature in features!{
            
            //context
            let drawCtxt = UIGraphicsGetCurrentContext()
            
            //face
            var faceRect = (feature as! CIFaceFeature).bounds
            faceRect.origin.y = imageReceivedImageView.image!.size.height - faceRect.origin.y - faceRect.size.height
            drawCtxt!.setStrokeColor(UIColor.red.cgColor)
            drawCtxt!.stroke(faceRect)
            
            //mouse
            if (feature as! CIFaceFeature).hasMouthPosition != false{
                let mouseRectY = imageReceivedImageView.image!.size.height - (feature as! CIFaceFeature).mouthPosition.y
                let mouseRect  = CGRect(x:(feature as! CIFaceFeature).mouthPosition.x - 5,y:mouseRectY - 5,width:10,height:10)
                drawCtxt!.setStrokeColor(UIColor.blue.cgColor)
                drawCtxt!.stroke(mouseRect)
            }
            
            //hige
            let higeImg      = UIImage(named:"hige_100.png")
            let mouseRectY = imageReceivedImageView.image!.size.height - (feature as! CIFaceFeature).mouthPosition.y
            //ヒゲの横幅は顔の4/5程度
            let higeWidth  = faceRect.size.width * 4/5
            let higeHeight = higeWidth * 0.3 // 元画像が100:30なのでWidthの30%が縦幅
            let higeRect  = CGRect(x:(feature as! CIFaceFeature).mouthPosition.x - higeWidth/2,y:mouseRectY - higeHeight/2,width:higeWidth,height:higeHeight)
            drawCtxt?.draw(higeImg!.cgImage!, in: higeRect)
            
            //leftEye
            if(feature as! CIFaceFeature).hasLeftEyePosition != false{
                let leftEyeRectY = imageReceivedImageView.image!.size.height - (feature as! CIFaceFeature).leftEyePosition.y
                let leftEyeRect  = CGRect(x:(feature as! CIFaceFeature).leftEyePosition.x - 5,y:leftEyeRectY - 5,width:10,height:10)
                drawCtxt!.setStrokeColor(UIColor.blue.cgColor)
                drawCtxt!.stroke(leftEyeRect)
            }
            
            //rightEye
            if (feature as! CIFaceFeature).hasRightEyePosition != false{
                let rightEyeRectY = imageReceivedImageView.image!.size.height - (feature as! CIFaceFeature).rightEyePosition.y
                let rightEyeRect  = CGRect(x:(feature as! CIFaceFeature).rightEyePosition.x - 5,y:rightEyeRectY - 5,width:10,height:10)
                drawCtxt!.setStrokeColor(UIColor.blue.cgColor)
                drawCtxt!.stroke(rightEyeRect)
            }
        }
        let drawedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageReceivedImageView.image = drawedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

