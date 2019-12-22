//
//  HomeViewController.swift
//  VideoTest
//
//  Created by Anastasia Petrova on 19/12/2019.
//  Copyright © 2019 Anastasia Petrova. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
}
