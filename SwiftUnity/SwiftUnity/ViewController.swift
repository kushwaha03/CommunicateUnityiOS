//
//  ViewController.swift
//  SwiftUnity
//
//  Created by Sandeep M on 29/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func thirdBtn(_ sender: Any) {
      
    }
    @IBAction func seButton(_ sender: Any) {
        UnityEmbeddedSwift.sendUnityMessage("Cube", methodName: "ChangeColor", message: "red")
    }
    @IBAction func clickAction(_ sender: Any) {
       print("ButtonCLicked")
        UnityEmbeddedSwift.showUnity()
        self.navigationController?.pushViewController(UnityEmbeddedSwift.getUnityRootC(), animated: true)

    }
    @IBOutlet weak var clickBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UnityEmbeddedSwift.showUnity()
        self.navigationController?.pushViewController(UnityEmbeddedSwift.getUnityRootC(), animated: true)
        print("ViewDidLoad")
      
    }


}

