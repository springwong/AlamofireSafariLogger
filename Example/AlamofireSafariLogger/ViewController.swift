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

    @IBOutlet weak var tvIntroduction: UITextView!
    @IBOutlet weak var tfInput: UITextField!
    @IBAction func callGithubAPI(_ sender: Any) {
        Alamofire.request(tfInput.text!)
    }
    
    @IBAction func postAPI(_ sender: Any) {
        let parameters: Parameters = ["foo": "bar"]
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.default)
    }
    
    @IBAction func getUrlEncoded(_ sender: Any) {
        let parameters: Parameters = ["foo": "bar"]
        
        // All three of these calls are equivalent
        Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default)

    }
    @IBAction func multipartAPI(_ sender: Any) {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("Hello World".data(using: .utf8)!, withName: "Multipart")
        },
            to: "https://httpbin.org/post",
            encodingCompletion: nil
        )
    }
    @IBAction func postJsonAPI(_ sender: Any) {
        let parameters: Parameters = ["foo": "bar"]
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tvIntroduction.text = "1.    Open Safari\n2.    Preference >> Advanced Tab >> Tick 'Show Develop menu in menu bar'\n3.    Developer Tab >> Find Simulator or your Device >> Click 'about blank' to open web inspector\n4.    Click 'Button' to call api and see the result\n5.    If you cannot find your simulator in developer tab, close your simulator and open again. Or re-open Safari"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

