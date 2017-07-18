//
//  WaitViewPresentable.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 18/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit

protocol WaitViewPresentable {
    var waitView: UIView { get set }
    var activityIndicator: UIActivityIndicatorView { get set }
    func showWaitView()
    func hideWaitView()
}

extension WaitViewPresentable {
    func showWaitView() {
        activityIndicator.startAnimating()
        waitView.isHidden = false
    }
    
    func hideWaitView() {
        activityIndicator.stopAnimating()
        waitView.isHidden = true
    }
    
    func buildWaitView(inside view: UIView) {
        waitView.isHidden = true
        waitView.addSubview(activityIndicator)
        view.addSubview(waitView)
        
        waitView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }
}
