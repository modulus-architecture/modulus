//
//  CameraPane.swift
//  Scaffolding
//
//  Created by Justin Smith on 7/16/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class CameraPane : UIViewController, UITextFieldDelegate
{
    var provider : CameraOwner!
    {
        didSet {
            provider.addObserver(observer: self)
        }
    }
    
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var xFov: UITextField!
    @IBOutlet weak var yFov: UITextField!
    @IBOutlet weak var orbitX: UITextField!
    @IBOutlet weak var orbitY: UITextField!
    @IBOutlet weak var orbitZ: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        distanceField.delegate = self
        xFov.delegate = self
        yFov.delegate = self
        orbitX.delegate = self
        orbitY.delegate = self
        orbitZ.delegate = self
        
        refresh()
    }
    
    func refresh() {
        if let provider = provider?.camera {
            distanceField?.text = String(provider.distance)
            xFov?.text = String(provider.xFov)
            yFov?.text = String(provider.yFov)
            orbitX?.text = String(provider.orbitX)
            orbitY?.text = String(provider.orbitY)
            orbitZ?.text = String(provider.orbitZ)

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        editingEnded(textField)
        return true
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        
        guard
            let text = sender.text,
            let float = Float(text)  else { return }
        
        switch sender{
            
        case distanceField:
            // update delegate with new value
            provider?.camera.distance = float
        case xFov:
            provider?.camera.xFov = float
        case yFov:
            provider?.camera.yFov = float
            
        case orbitX:
            provider?.camera.orbitX = float
            
        case orbitY:
            provider?.camera.orbitY = float
            
        case orbitZ:
            provider?.camera.orbitZ = float
            
        default:
            return
        }
    }
}

extension CameraPane : CameraObserver {
    func owner(_ owner: CameraOwner, didChange camera: Camera) {
        refresh()
    }
}

extension CameraPane {
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        self.refresh()
    }
}

