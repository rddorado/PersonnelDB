//
//  PersonnelListViewController.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

enum SearchType {
    case name
    case job
    case skills
    case years
    case all
}

class PersonnelListViewController: UIViewController, WaitViewPresentable {
    var ref: DatabaseReference?
    var isKeyboardShown: Bool = false
    var persons:[Person]?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var waitView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    lazy var searchbar: UISearchBar = {
        let searchbar = UISearchBar(frame: CGRect.zero)
        searchbar.placeholder = "Search for personnel detail"
        searchbar.autocapitalizationType = .none
        searchbar.autocorrectionType = .no
        searchbar.delegate = self
        searchbar.showsCancelButton = true
        return searchbar
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "List of Personnel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        buildView()
        buildConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        showWaitView()
        search(for: "")
    }
    
    fileprivate func buildView() {
        view.backgroundColor = .white
        view.addSubview(searchbar)
        view.addSubview(tableView)
        buildWaitView(inside: view)
        
    }
    
    fileprivate func buildConstraints() {
        searchbar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        tableViewRemakeConstrains()
    }
    
    func tableViewRemakeConstrains(bottomInset: CGFloat = 0) {
        tableView.snp.remakeConstraints() { make in
            make.top.equalTo(searchbar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomInset)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        isKeyboardShown = true
        let info  = notification.userInfo!
        guard let rawFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardFrame = view.convert(rawFrame, from: nil)
        print(keyboardFrame)
        UIView.animate(withDuration: 1, animations: {
            self.tableViewRemakeConstrains(bottomInset: keyboardFrame.height)
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardDidHide(notification: NSNotification) {
        isKeyboardShown = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PersonnelListViewController {
    fileprivate func search(for searchString: String) {
        DispatchQueue.global(qos: .background).async {
            guard let localRef = self.ref?.child("personneldb").child("personnel") else {
                return
            }
            
            let _ = localRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
                
                guard let snapshotArray = snapshot.value as? [[String:Any]] else {
                    self.filter(results: [], with: searchString)
                    return
                }
                
                var persons = [Person]()
                for result in snapshotArray{
                    let person = Person(firebaseResult: result)
                    persons.append(person)
                    print("person = \(person)")
                }
                self.filter(results: persons, with: searchString)
            })
        }
    }
    
    fileprivate func filter(results: [Person], with searchString: String, type: SearchType = .all) {
    
        var filtered = [Person]()
        
        if searchString.isEmpty {
            filtered = results
        } else {
            filtered = results.filter { person in
                self.filter(person: person, searchString: searchString, type: type)
            }
        }
        self.updateView(with: filtered)
    }

    
    fileprivate func filter(person: Person, searchString: String, type: SearchType) -> Bool {
        var isNameMatched = person.name.lowercased().contains(searchString)
        var isJobMatched = person.jobTitle.lowercased().contains(searchString)
        var isYearsOfExperieceMatched = person.yearsOfExperience.lowercased().contains(searchString)
        var isSkilsMatched = person.description.lowercased().contains(searchString)
        
        switch type {
        case .name:
            isJobMatched = false
            isYearsOfExperieceMatched = false
            isSkilsMatched = false
        case .job:
            isNameMatched = false
            isYearsOfExperieceMatched = false
            isSkilsMatched = false
        case .years:
            isNameMatched = false
            isJobMatched = false
            isSkilsMatched = false
        case .skills:
            isNameMatched = false
            isJobMatched = false
            isYearsOfExperieceMatched = false
        default:
            break
        }
        
        return isNameMatched || isJobMatched || isYearsOfExperieceMatched || isSkilsMatched
    }
    
    fileprivate func updateView(with persons: [Person]) {
        DispatchQueue.main.async {
            self.persons = persons
            self.tableView.reloadData()
            self.hideWaitView()
        }
    }
}

extension PersonnelListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Default")
        
        cell.textLabel?.text = persons?[indexPath.row].name ?? ""
        cell.detailTextLabel?.text = persons?[indexPath.row].jobTitle ?? ""
        return cell
    }
}

extension PersonnelListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(PersonnelDetailViewController(person: persons?[indexPath.row]), animated: true)
    }
}

extension PersonnelListViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        showWaitView()
        search(for: searchbar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  let text = searchbar.text, text.isEmpty {
            search(for: searchbar.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showWaitView()
        search(for: searchbar.text ?? "")
        searchbar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
    }
}
