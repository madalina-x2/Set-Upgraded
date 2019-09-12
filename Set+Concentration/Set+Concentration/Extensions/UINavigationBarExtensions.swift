//
//  UINavigationBarExtensions.swift
//  Set+Concentration
//
//  Created by Madalina Sinca on 12/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = CGFloat(50)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        tabBarController?.tabBar.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
    }
}
