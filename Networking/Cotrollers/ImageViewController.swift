//
//  ImageViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 27.07.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    let urlForUpload = "https://i.pinimg.com/originals/6f/26/61/6f2661c8ec1901abc6804488179bab0e.png"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelCompletedLoading:UILabel!
    @IBOutlet weak var progressView:UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        labelCompletedLoading.textColor = .black
        labelCompletedLoading.isHidden = true
        progressView.isHidden = true
    }
    
    func fetchImage() {
       
        NetworkingManager.downloadImage { (image) in
            
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
           
        }
    }
    func fetchDownloadImageAlamofire() {
        
        
    AlamofireClassRequest.downloadImageAlamofire(imageURL: imageDownload) { (image) in
       
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            
        
        }
    }
    
    func uploadImageAlamofire() {
        
        
        
        AlamofireClassRequest.inProgress = { progress in
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireClassRequest.completed = { [self] completion in
            self.labelCompletedLoading.isHidden = false
            self.labelCompletedLoading.text = "Loading is \(completion)"
            self.labelCompletedLoading.text?.removeLast(10)
        }
        
        AlamofireClassRequest.uploadImageWithProgressBar(url: urlForUpload) { (image) in
            self.labelCompletedLoading.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
        }
    }
}
