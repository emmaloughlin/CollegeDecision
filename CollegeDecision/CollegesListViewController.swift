//
//  ViewController.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/27/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn

class CollegesListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfReviews: UILabel!
    
    var colleges: Colleges!
    var authUI: FUIAuth!
    var reviews: Reviews! // ADDED THIS 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        colleges = Colleges()
        authUI = FUIAuth.defaultAuthUI()

//        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        
    
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.register(CollegesTableViewCell.self, forCellReuseIdentifier: "CollegeCell")
        tableView.isHidden = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: false)
        colleges.loadData {
            

            self.tableView.reloadData()
            self.sortForSegmentPressed()
            
            self.numberOfReviews.text = String(self.reviews.reviewArray.count) // THIS CHANGED
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCollege" {
            let destination = segue.destination as! CollegesDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.college = colleges.collegeArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    
    // SORT MY TABLEVIEW 
    func sortForSegmentPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: // A-Z
            colleges.collegeArray.sort(by: {$0.name < $1.name})
        case 1: // z-a
            colleges.collegeArray.sort(by: {$0.name > $1.name})
        default:
            print("*** ERROR: Segmented control should just have 2 segments")
        }
        tableView.reloadData()
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortForSegmentPressed()
    }
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("*** Successful sign out!")
            tableView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
            print("*** ERROR: Could not sign out")
        }
    }
}

extension CollegesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("We have \(colleges.collegeArray.count) rows")
        return colleges.collegeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollegeCell", for: indexPath) as! CollegesTableViewCell
        
//        cell.college = colleges.collegeArray[indexPath.row]
        
        cell.nameLabel?.text = colleges.collegeArray[indexPath.row].name
        print("Returning cell for \(colleges.collegeArray[indexPath.row].name)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension CollegesListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
                tableView.isHidden = false
                print("*** We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }

    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
