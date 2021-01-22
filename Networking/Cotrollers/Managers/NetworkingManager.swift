//
//  NetworkingManager.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 28.12.20.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//
import UIKit
import Foundation


class NetworkingManager {
    
    
    
    
    static func getRequest() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    
    static func postRequest() {
        
            
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            
            let userData = ["Course": "Networking", "Lesson": "GET and POST"]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                
                guard let response = response, let data = data else { return }
                
                print(response)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            } .resume()
        
    }
    
    static func downloadImage( competionHandler: @escaping (_ image:UIImage)-> ()) {
        
        guard let url = URL(string: imageDownload) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    competionHandler(image)
                }
            }
        } .resume()
    }
    
    
    static func  fetchAlamofireData(comletionHander:@escaping([Course]) -> ()) {
        let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
        AlamofireClassRequest.requestAlamofire(url: url) { courses in
            comletionHander(courses)
        }
    }
    
    static func fetchData(url:String,completionHandler:@escaping ([Course]) -> ()) {
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completionHandler(courses)
               
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    static func alamofireRequestSender () {
        
    }
    
    static func downloadImage(url:String) {
   
        guard let url = URL(string: url) else {return}
        let image = UIImage(named: "me")!
        guard let dataImageDownload = DownloadImage(withImage: image, forKey: "image") else {return}
        var request = URLRequest(url: url)
        let httpHeader = ["Authorization" : "Client-ID 13cef97d61002c1"]
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeader
        
        request.httpBody = dataImageDownload.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            
            if let data = data {
               
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
