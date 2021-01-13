//
//  SearchVC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 09/06/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SearchUserTVCell"

class SearchVC: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Properties
    
    var users = [User]()
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        tableView.register(SearchUserTVCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)

        configureSearchBar()
        
        fetchUsers()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserTVCell
        
        // configure cell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let userProfileVC = UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
        
    }
    
    //MARK: - Handlers
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self // delegate to this class inheriting from added SearchBarDelegate
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    // MARK: - UISearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
//        searchBar.showsCancelButton≥≥
    }
    
    //MARK: - API
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (dataSnapshot) in
            // childAdded works simmilar to loops, looking for each child
            let uid = dataSnapshot.key

            Database.fetchUser(withUid: uid) { (user) in
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
}
