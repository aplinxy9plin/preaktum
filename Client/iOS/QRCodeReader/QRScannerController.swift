//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Nikita Aplin on 23/11/2017.
//  Copyright © 2017 Aplin. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var navigationBAR: UINavigationItem!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var imageRecOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shotButton: UIButton!
    struct global {
        static var products = ["text"]
    }
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                        AVMetadataObject.ObjectType.code39,
                        AVMetadataObject.ObjectType.code39Mod43,
                        AVMetadataObject.ObjectType.code93,
                        AVMetadataObject.ObjectType.code128,
                        AVMetadataObject.ObjectType.ean8,
                        AVMetadataObject.ObjectType.ean13,
                        AVMetadataObject.ObjectType.aztec,
                        AVMetadataObject.ObjectType.pdf417,
                        AVMetadataObject.ObjectType.qr]
    
    @IBOutlet weak var basket_button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = #imageLiteral(resourceName: "barcode_back.png")
        //basket_button.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //navigationBAR.barTi
        //global.products.removeFirst()
        //print(global.products[0])
        tableView.isHidden = true
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            //view.bringSubview(toFront: messageLabel)
            //view.bringSubview(toFront: topbar)
            //view.bringSubview(toFront: imageRecOutlet)
            view.bringSubview(toFront: tableView)
            //view.bringSubview(toFront: shotButton)
            view.bringSubview(toFront: background)

            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                /*qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)*/
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            //print(error)
            return
        }
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
    }

    @IBAction func shot(_ sender: Any) {
        captureSession?.stopRunning()
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as! AVCapturePhotoCaptureDelegate)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showTableView(_ sender: Any) {
        /*if(tableView.isHidden){
            self.captureSession?.stopRunning()
            tableView.isHidden = false
        }else{
            self.captureSession?.startRunning()
            tableView.isHidden = true
        }*/
    }
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR/barcode is detected"
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                // Create the alert controller
                let alertController = UIAlertController(title: "Title", message: "Price: $100", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    if(global.products[0] == "text"){
                        global.products.removeFirst()
                    }
                    global.products.append(metadataObj.stringValue!)
                    let json: [String: Any] = ["type": "add", "barcode": metadataObj.stringValue!]
                    //self.getRequest(json: json)
                    self.sendRequest()
                    print(metadataObj.stringValue!)
                    //productsStruct.countP += 1å
                    self.captureSession?.startRunning()
                    self.messageLabel.text = "No QR/barcode is detected"
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    for x in global.products{
                        print(x)
                    }
                    self.captureSession?.startRunning()
                    self.messageLabel.text = "No QR/barcode is detected"
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                captureSession?.stopRunning()
            }
        }
    }
    func sendRequest() {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (POST http://13.95.174.54/server/test.php)
         */
        
        guard let URL = URL(string: "http://192.168.0.101/upload/upload.php") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        // Headers
        
        //request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        // JSON Body
        
        let bodyObject: [String : Any] = [
            "test": "xuy"
        ]
        //request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        //NSData.dataWithData(UIImagePNGRepresentation(imageData))
        
        /* Start a new Task */
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
