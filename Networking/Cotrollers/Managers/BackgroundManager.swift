//
//  BackgroundManager.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 6.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation
import UIKit

class BackgroundManager:NSObject {
    
    private var downloadTask:URLSessionDownloadTask!
    var fileLocation: ((URL) -> ())?
    var onProgress:((Double)-> ())?
    // создаем сессию с конфигом бэкаграунд загрузки
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "vadzim.team.Networking")
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    
    // Создаем загрузку
    func startDownload() {
        guard let url = URL(string: fileForDownload ) else {return}
        downloadTask = bgSession.downloadTask(with: url)
        downloadTask.earliestBeginDate = Date().addingTimeInterval(3) // загрузка начнется через 3 секунды
        downloadTask.countOfBytesClientExpectsToSend = 512
        downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
        downloadTask.resume()
    }
    
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension BackgroundManager: URLSessionDelegate {
   
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHander = appDelegate.bgCompletionHandler
            else {return}
            
            appDelegate.bgCompletionHandler = nil
            completionHander()
        }
    }
    
}

extension BackgroundManager:URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download loading did finish: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            
            self.fileLocation?(location)
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
         // ????
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {return}
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Total progress: \(progress)")
        
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
