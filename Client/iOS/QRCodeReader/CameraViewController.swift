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
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        view.bringSubview(toFront: imageView)
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
            print(imageData)
            image = UIImage(data: imageData)
            imageView.image = image
            
            /*let sessionConfig = URLSessionConfiguration.default
            
            /* Create session, and optionally set a URLSessionDelegate. */
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            /* Create the Request:
             Request (POST http://localhost/upload/upload.php)
             */
            
            guard var URL = URL(string: "http://192.168.0.101/upload/upload.php") else {return}
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            // Headers
            
            request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            
            //request.httpBody(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
            /* Start a new Task */
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                }
                else {
                    // Failure
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            */
            
            //sendRequest(imageData: imageData)
            if let image = image {
                let imageData1 = UIImageJPEGRepresentation(imageView.image!, 1.0)
                
                let urlString = "http://192.168.0.101/upload/upload.php"
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
                
                mutableURLRequest.httpBody = uploadData as Data
                
                
                let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if error == nil {
                        print("SUCCESS")
                        let statusCode = (response as! HTTPURLResponse).statusCode
                        print(statusCode)
                        let responseString = String(data: data!, encoding: .utf8)
                        print("responseString = \(String(describing: responseString))")
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
