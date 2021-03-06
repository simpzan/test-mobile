//
//  ViewController.swift
//  QR
//
//  Created by Samuel Zhang on 7/21/16.
//  Copyright © 2016 Samuel Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import PKHUD

class ViewController: UIViewController {
    lazy var readerVC:QRCodeReaderViewController = {
        let reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        let vc = QRCodeReaderViewController(cancelButtonTitle:"Cancel", coderReader:reader, startScanningAtLoad: true, showSwitchCameraButton:false, showTorchButton:false)
        vc.title = "QR Scan"
        return vc
    }()
    
    func validateSeed(seed:String) {
        HUD.show(.LabeledProgress(title:"validating seed", subtitle:seed))
        
        let seedManager = SeedManager.sharedInstance
        seedManager.validateSeed(seed, callback: { (valid) -> Void in
            var type: HUDContentType
            if valid == nil {
                type = .LabeledError(title:"connectivity error", subtitle: nil)
            } else if valid! {
                type = .LabeledSuccess(title:"valid seed", subtitle: seed)
            } else {
                type = .LabeledError(title:"invalid seed", subtitle: seed)
            }
            HUD.flash(type, delay: 2.0) { _ in
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
    @IBAction func scanQR(sender: AnyObject) {
        readerVC.completionBlock = { (result: String?) in
            guard let seed = result else {
                self.navigationController?.popViewControllerAnimated(true)
                return
            }
            self.validateSeed(seed)
        }
        
        self.navigationController?.pushViewController(readerVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

