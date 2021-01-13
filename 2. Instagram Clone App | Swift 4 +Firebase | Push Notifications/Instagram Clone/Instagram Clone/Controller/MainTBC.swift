//
//  MainTBC.swift
//  Instagram Clone
//
//  Created by Mateusz Sarnowski on 05/07/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase

class MainTBC: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    let dot = UIView()
    var notificationIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        configureViewControllers()
        
        // configure notification dot
        configureNotificationDot()
        
        // user validation
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Handlers
    
    // function to create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        
        // home feed controller
        let feedCVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedCVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search feed controller
        let searchVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC())
        
        // select image controller
        let selectImageCVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        // notification controller
        let notificationsVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsVC())
        
        // profile controller
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileCVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // view controllers to be added to tab controller
        viewControllers = [feedCVC, searchVC, selectImageCVC, notificationsVC, userProfileVC]
        
        tabBar.tintColor = .black
    }
    
    func configureNotificationDot() { /// slowing the software from 11s to 48s to fully load an app
//        if UIDevice().userInterfaceIdiom == .phone {
//            let tabBarHeight = tabBar.frame.height
//
//            if UIScreen.main.nativeBounds.height == 2436 {
//                // configure dot for iPhone X
//                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6, height: 6)
//            } else {
//                // configure dot for other iPhone models
//                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - 16, width: 6, height: 6)
//            }
//            dot.center.x = (view.frame.width / 5 * 3 + (view.frame.width / 5) / 2)
//            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
//            dot.layer.cornerRadius = dot.frame.width / 2
//            dot.isHidden = true
//            self.view.addSubview(dot)
//        }
    }
    
    // MARK: - UITabBarController
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let selectImageCVC = SelectImageCVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageCVC)
            navController.navigationBar.tintColor = .black
            present(navController, animated: true, completion: nil)
            return false
        }
        if index == 3 {
            observeNotifications()
        }
        
        return true
    }
    
    /// construct navigation controllers
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginVC())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
    func observeNotifications() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }
        self.notificationIdArray.removeAll() // to remove all elements from Array when the user is changed

        Database.database().reference().child("notifications").child(currentUid).observeSingleEvent(of: .value) { (dataSnapshot) in // cannot be observe(childAdded) because it will listen for every change in this directory
            
            guard let allObjects = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.forEach { (dataSnapshot) in
                
                let notificationId = dataSnapshot.key
                
                Database.database().reference().child("notifications").child(currentUid).child(notificationId).child("checked").observeSingleEvent(of: .value) { (dataSnapshot) in
                    guard let checked = dataSnapshot.value as? Int else { fatalError() }
                    
                    if checked == 0 {
                        self.dot.isHidden = false
                        Database.database().reference().child("notifications").child(currentUid).child(notificationId).child("checked").setValue(1)
                        
                    } else {
                        self.dot.isHidden = true

                    }
                } // observerSingleEvent because we are observing one value
            }
        }
    }
    
    func setNotficationsToChecked() {
        guard let currentUid = Auth.auth().currentUser?.uid else { fatalError() }

        for notificationId in notificationIdArray {
            Database.database().reference().child("notifications").child(currentUid).child(notificationId).child("checked").setValue(1)
        }
    }
}
