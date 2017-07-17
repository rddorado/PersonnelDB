//
//  PersonnelDetailViewController.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit
import SnapKit

class PersonnelDetailViewController: UIViewController {
    lazy var lastBottomConstraint: SnapKit.ConstraintItem = self.scrollView.snp.top
    let scrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: CGRect.zero)
        scrollview.backgroundColor = .white
        return scrollview
    }()
    let nameTitle: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "NAME"
        label.setCustomStyleSmallTitle()
        return label
    }()
    let name: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        return label
    }()
    let jobTitle: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "JOB TITLE"
        label.setCustomStyleSmallTitle()
        return label
    }()
    let job: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        return label
    }()
    let yearsOfExperienceTitle: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "YEARS OF EXPERIENCE"
        label.setCustomStyleSmallTitle()
        return label
    }()
    let yearsOfExperience: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        return label
    }()
    let skillsTitle: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "SKILLS"
        label.setCustomStyleSmallTitle()
        return label
    }()
    let skills: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init(person: Person?) {
        super.init(nibName: nil, bundle: nil)
        title = "Personnel Details"
        view.backgroundColor = .white
        name.text = person?.name
        job.text = person?.jobTitle
        yearsOfExperience.text = person?.yearsOfExperience
        skills.text = person?.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(exitViewController))
        buildView()
        buildConstraints()
    }
    
    func exitViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func buildView() {
        view.addSubview(scrollView)
        addToScrollView(views: nameTitle, name, jobTitle, job, yearsOfExperienceTitle, yearsOfExperience, skillsTitle, skills)
        
    }
    
    private func buildConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupConstraint(for view: UIView) {
        view.snp.makeConstraints { make in
            make.top.equalTo(lastBottomConstraint)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(30)
            make.width.equalToSuperview().inset(32)
        }
        lastBottomConstraint =  view.snp.bottom
    }
    
    private func setupLastConstraint(for view: UIView) {
        view.snp.makeConstraints { make in
            make.top.equalTo(lastBottomConstraint)
            make.left.right.bottom.equalToSuperview().inset(32)
            make.height.equalTo(30)
            make.width.equalToSuperview().inset(32)
        }
    }
    
    func addToScrollView(views: UIView...) {
        for (index, view) in views.enumerated() {
            scrollView.addSubview(view)
            if index == views.count - 1 {
                setupLastConstraint(for: view)
            } else {
                setupConstraint(for: view)
            }
        }
    }
}
