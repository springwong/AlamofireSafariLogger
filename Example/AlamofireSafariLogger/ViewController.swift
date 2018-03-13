//
//  ViewController.swift
//  AlamofireSafariLogger
//
//  Created by rudolphwong2002@gmail.com on 03/13/2018.
//  Copyright (c) 2018 rudolphwong2002@gmail.com. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBAction func callGithubAPI(_ sender: Any) {
        Alamofire.request("https://httpbin.org/get")
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

