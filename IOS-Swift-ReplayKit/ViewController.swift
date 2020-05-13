//
//  ViewController.swift
//  IOS-Swift-ReplayKit
//
//  Created by Pooya Hatami on 2018-03-13.
//  Copyright © 2018 Pooya Hatami. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {

    let recorder = RPScreenRecorder.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    @IBAction func toggleRecording1(_ sender: UIBarButtonItem) {
        let r = RPScreenRecorder.shared()
        
        DispatchQueue.main.async {
            
        guard r.isAvailable else {
            print("ReplayKit unavailable")
            return
        }
        
        if r.isRecording {
            print("stopRecording")
            self.stopRecording(sender, r)
            
        }
        else {
            print("startRecording")
            self.startRecording(sender, r)
        }
        }

    }

    

func startRecording(_ sender: UIBarButtonItem, _ r: RPScreenRecorder) {
    
    r.startRecording(handler: { (error: Error?) -> Void in
        if error == nil { // Recording has started
            sender.title = "Stop"
        } else {
            // Handle error
            print(error?.localizedDescription ?? "Unknown error")
        }
    })
}

func stopRecording(_ sender: UIBarButtonItem, _ r: RPScreenRecorder) {
    r.stopRecording( handler: { previewViewController, error in
        
        sender.title = "Record"
        
        if let pvc = previewViewController {
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                pvc.modalPresentationStyle = UIModalPresentationStyle.popover
                pvc.popoverPresentationController?.sourceRect = CGRect.zero
                pvc.popoverPresentationController?.sourceView = self.view
            }
            
            pvc.previewControllerDelegate = self as RPPreviewViewControllerDelegate
            self.present(pvc, animated: true, completion: nil)
        }
        else if let error = error {
            print(error.localizedDescription)
        }
        
    })
}

//// MARK: RPPreviewViewControllerDelegate
//func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
//    previewController.dismiss(animated: true, completion: nil)
//}
    
}

extension ViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
