//
//  CollectionViewController.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 27.12.20.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

private let reuseIdentifier = "cell"



enum Buttons:String, CaseIterable {
    
    case downloadImage = "Download Image"
    case getRequest = "Get Request"
    case postRequest = "Post Request"
    case courses = "Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case alamofire = "Courses Alamofire"
    case downloadImageAlamofire = "Download Image Alamofire"
    case uploadImageAlamofire = " Upload Image Alamofire"
    case postRequestAlamofire = "postRequestAlamofire"
    case uploadInServerAlamofire = "Upload image at Server"
}



class MainScreenController: UICollectionViewController {

  //  private let buttons = ["Download Image", "Get Request", "Post Request", "Courses", "Upload Image"]
    private var alert:UIAlertController!
    private let buttons = Buttons.allCases
    private var downloadData = BackgroundManager()
    private var filePath:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationRegisterAndRequest()
        self.downloadData.fileLocation = { (location) in
            print("Download file: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.pushNotification()
            self.alert.dismiss(animated: true, completion: nil)
            
            
        }
        
        checkLogInUser()
    }

    private func alertDownloadCreate() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.downloadData.stopDownload()
        }
        
        let hight = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        
        alert.view.addConstraint(hight)
        alert.addAction(alertCancel)
       
        present(alert, animated: true) {
            self.createActivityIndicator()
            self.createProgressView()
           
        }
        
    }

    private func createActivityIndicator() {
        let size = CGSize(width: 40, height: 40)
        let points = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: points, size: size))
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        self.alert.view.addSubview(activityIndicator)
        
    }
    
    private func createProgressView() {
        let sizeAndPoints = CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2)
        let progressView = UIProgressView(frame: sizeAndPoints)
        progressView.tintColor = .blue
        
        self.downloadData.onProgress = { (progress) in
            progressView.progress = Float(progress)
            self.alert.message = String(Int(progress * 100)) + "%"
        }
        
        self.alert.view.addSubview(progressView)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return buttons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = buttons[indexPath.row].rawValue
       
    
        return cell
    }

    
//     Uncomment this method to specify if the specified item should be selected
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let selectedItem = buttons[indexPath.row]
        
        
        switch selectedItem {
        case .downloadImage:
            performSegue(withIdentifier: "imageSegue", sender: self)
        case .getRequest:
            NetworkingManager.getRequest()
        case .postRequest:
            NetworkingManager.postRequest()
        case .courses:
            performSegue(withIdentifier: "CoursesSegue", sender: self)
        case .uploadImage:
            NetworkingManager.downloadImage(url: "https://api.imgur.com/3/image")
        case .downloadFile:
            alertDownloadCreate()
            self.downloadData.startDownload()
        case .alamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamofire", sender: self)
        case .downloadImageAlamofire:
            performSegue(withIdentifier: "DownloadImageAlamofire", sender: self)
        case .uploadImageAlamofire:
        performSegue(withIdentifier: "UploadImage", sender: self)
        case .postRequestAlamofire:
            performSegue(withIdentifier: "postAlamofire", sender: self)
        case .uploadInServerAlamofire:
            AlamofireClassRequest.AlamofireUploadImageAtServer(url: "https://api.imgur.com/3/image") { courses in
                
            }
        }
        
       
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
         let courseVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        switch segue.identifier {
        case "CoursesSegue":
            courseVC?.fetchData()
        case "OurCoursesWithAlamofire":
            courseVC?.fetchAlamofire()
        case "DownloadImageAlamofire":
            imageVC?.fetchDownloadImageAlamofire()
        case "imageSegue":
            imageVC?.fetchImage()
        case "UploadImage":
            imageVC?.uploadImageAlamofire()
        case "postAlamofire":
            courseVC?.postNewCourse()
        default:
            break
        }
    }
}

extension MainScreenController {
    
    private func notificationRegisterAndRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { _, _ in
        }
    }
    
    private func pushNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download is completed!"
        content.body = "Your file have path: \(filePath.description)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferDownload", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension MainScreenController {
    
    private func checkLogInUser () {
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                
                let  mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginStoryboard = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                self.present(loginStoryboard, animated: true, completion: nil)
            }
        }
        
    }
}
