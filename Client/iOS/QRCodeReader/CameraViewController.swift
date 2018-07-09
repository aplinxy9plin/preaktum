//
//  CameraViewController.swift
//  Easy Pay
//
//  Created by Никита Аплин on 03.12.2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var image_background: UIImageView!
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.tabBarController?.tabBar.isHidden = true
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        view.bringSubview(toFront: imageView)
        view.bringSubview(toFront: image_background)
        view.bringSubview(toFront: cameraButton)

        // Do any additional setup after loading the view.
    }
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch{
            print(error)
        }
    }
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        //performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CameraViewController: AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            captureSession.stopRunning()
            // Create the alert controller
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            //create an activity indicator
            let indicator = UIActivityIndicatorView(frame: alertController.view.bounds)
            indicator.color = UIColor.black
            let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            indicator.transform = transform
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //add the activity indicator as a subview of the alert controller's view
            alertController.view.addSubview(indicator)
            //alertController.view.setValue(indicator, forKey: "alertController")
            indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
            indicator.startAnimating()
            present(alertController, animated: true, completion: nil)
 
            
            print(imageData)
            image = UIImage(data: imageData)
            let scale = 1500 / (image?.size.width)!
            let newHeight = (image?.size.height)! * scale
            UIGraphicsBeginImageContext(CGSize(width: 1500, height: newHeight))
            image?.draw(in: CGRect(x: 0, y: 0, width: 1500, height: newHeight))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView.image = newImage
            if let image = image {
                let imageData1 = UIImageJPEGRepresentation(imageView.image!, 1.0)
                
                let urlString = "http://109.124.51.82/upload/upload.php"
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                let mutableURLRequest = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                
                mutableURLRequest.httpMethod = "POST"
                
                let boundaryConstant = "----------------12345";
                let contentType = "multipart/form-data;boundary=" + boundaryConstant
                mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
                
                // create upload data to send
                let uploadData = NSMutableData()
                
                // add image
                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(imageData1!)
                uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
               
                /*
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                //create an activity indicator
                let indicator = UIActivityIndicatorView(frame: alertController.view.bounds)
                indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                //add the activity indicator as a subview of the alert controller's view
                alertController.view.addSubview(indicator)
                indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
                var statusCode = 0
                while(statusCode == 0){
                    indicator.startAnimating()
                }
                indicator.stopAnimating()
                let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                */
 
 
                mutableURLRequest.httpBody = uploadData as Data
                
                
                let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if error == nil {
                        print("SUCCESS")
                        alertController.dismiss(animated: true, completion: nil)
                        var statusCode = (response as! HTTPURLResponse).statusCode
                        print(statusCode)
                        let responseString = String(data: data!, encoding: .utf8)
                        print("responseString = \(String(describing: responseString))")
                        // Create the alert controller
                        let alertController = UIAlertController(title: responseString, message: "Цена: $3.75", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Добавить", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            if(QRScannerController.global.products[0] == "text"){
                                QRScannerController.global.products.removeFirst()
                            }
                            let test = String(describing: responseString)
                            QRScannerController.global.products.append(test)
                            //productsStruct.countP += 1å
                            self.captureSession.startRunning()
                        }
                        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel) {
                            UIAlertAction in
                            for x in QRScannerController.global.products{
                                print(x)
                            }
                            self.captureSession.startRunning()
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)

                        //print(String(describing: response))
                        // Image uploaded
                    }else{
                        print("ERRORRRR")
                    }
                })
                
                task.resume()
                
            }
        }
    }
}
