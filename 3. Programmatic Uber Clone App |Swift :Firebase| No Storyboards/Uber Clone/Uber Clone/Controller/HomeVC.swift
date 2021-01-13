//
//  HomeVC.swift
//  Uber Clone
//
//  Created by Mateusz Sarnowski on 06/10/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "LocationTVCell"

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private let locationInputViewHeight = 200
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        configureNagivationBar()
        checkIfUserIsLoggedIn()
//        handleLogout()
        enableLocationServices()
        
    }
    
    // MARK: - Auxiliary functions
    
    func configureNagivationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func configureUI() {
        configureMapView()
        
        view.addSubview(locationInputActivationView)
        locationInputActivationView.centerX(inView: view)
        locationInputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        locationInputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        locationInputActivationView.alpha = 0
        locationInputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.locationInputActivationView.alpha = 1
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 1, animations: {
            self.locationInputView.alpha = 1
        }) { (_) in
            print("DEBUG: configureLocationInputView()")
        }
    }
    
    func configiureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationTVCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        let height = view.frame.height - 200
        ta
    }
    
    // MARK: - Selectors
    
    @objc func handleLogout() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) in
//            do {
//                try Auth.auth().signOut()
//                print("signed out")
//            } catch {
//                print("DEBUG: \(error.localizedDescription)")
//            }
//        }))
        print("handleLogout()")
        do {
            try Auth.auth().signOut()
            print("signed out")
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginVC())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: false, completion: nil)
            }
        } else {
            configureUI()
        }
    }
}

// MARK: - Location services

extension HomeVC: CLLocationManagerDelegate {
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: authorized always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: authorized when in use")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}

extension HomeVC: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        print("DEBUG: presentLocationInputView() from HomeVC.swift")
        locationInputActivationView.alpha = 0
        configureLocationInputView()
    }
}


extension HomeVC: LocationInputViewDelegate {
    func dismissLocationInputView() {
        print("DEBUG: back()")
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.locationInputActivationView.alpha = 1
            }
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTVCell
        return cell
    }
    
    
}
