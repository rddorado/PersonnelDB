//
//  PersonnelListViewController.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit

class PersonnelListViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "List of Personnel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
