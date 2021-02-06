//
//  LoginViewController.swift
//  UINavigationController-Example
//
//  Created by strawb3rryx7 on 12.12.2017.
//  Copyright © 2017 strawb3rryx7. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    lazy var launchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Launch", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 142.0/255.0, green: 68.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(launchButton)

        launchButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        launchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        launchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        launchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onButtonPressed(_ sender: UIButton) {
        UnityEmbeddedSwift.showUnity()
        
    }

}
