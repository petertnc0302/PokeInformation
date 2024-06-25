//
//  BaseViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 22/6/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }

    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }

    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
}
