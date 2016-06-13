//
//  ViewController.swift
//  FloatingHintTextField
//
//  Created by Pereiro, Delfin on 06/11/2016.
//  Copyright (c) 2016 Pereiro, Delfin. All rights reserved.
//

import UIKit
import FloatingHintTextField

class ViewController: UIViewController {

    @IBOutlet weak var floatingHintTextView: FloatingHintTextField!
    @IBOutlet weak var mNormalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        floatingHintTextView.placeholderColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

