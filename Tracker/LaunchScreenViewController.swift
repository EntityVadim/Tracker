//
//  LaunchScreenViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import Foundation
import UIKit

final class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlue
        
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 91),
            imageView.heightAnchor.constraint(equalToConstant: 94)
        ])
    }
}
