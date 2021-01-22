//
//  AlamofireOurCoursesSender.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 11.01.21.
//  Copyright © 2021 Vadzim Ivanchanka. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireClassRequest {
    
    static var inProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?
    
    static func requestAlamofire(url:String, completionHander: @escaping([Course]) -> ()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { (response) in
            //  если нет validate то ответ будет всегда положительный(кроме отсутсвия инета)
            
            switch response.result {
            case .success(let value):
                
                 guard let courses = Course.getArray(from: value) else {return}
               completionHander(courses)
                
                
                
            case .failure(let error):
                print(error)
            }
         /*
            guard let statusCode = response.response?.statusCode else {return}
            
            print("Status code: ", statusCode)
            
            // возвращает тру если в диапазоне  этих чисел сттатус код
            if (200..<300).contains(statusCode) {
                let value = response.value
                print("value:", value ?? "nil")
            } else {
                print(response.error ?? "error")
            }
        */
        }
        
    }
    
    static func downloadImageAlamofire(imageURL:String, completionHandler:@escaping (UIImage)-> ()) {
        guard let url = URL(string: imageURL) else { return }
        
        AF.request(url, method:.get).responseData { data in
            
            switch data.result {
            case .success(let data):
                guard let image = UIImage(data: data) else {return}
                completionHandler(image)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    static func uploadImageWithProgressBar(url:String, completionHandler: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: url) else {return}
        AF.request(url).downloadProgress { progress in
            self.inProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }.response { response in
            guard let data = response.data, let image = UIImage(data: data) else {return}
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    
    static func postRequestAlamofire(url:String, completionHandler:@escaping ([Course]) -> ()) {
        
        guard let url = URL(string: url) else {return}
        
        let userData:[String:Any] = ["name":"Networking Course",
                        "link":"vk.com",
                        "imageUrl":"https://www.pinningpro.com/wp-content/uploads/2019/07/best-pinterest-tools-courses.jpg",
                        "number_of_lessons":10,
                        "number_of_tests":4 ]
                      
        AF.request(url, method: .post, parameters: userData).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {return}
            print(statusCode)
            
            switch response.result{
            case .success(let value):
                // ???? понять
                guard let jsonObject = value as? [String:Any], let course = Course(json: jsonObject) else {return}
                
                var courses = [Course]()
                
                courses.append(course)
                
                completionHandler(courses)
                
            case .failure(let error):
                print(error)
        }
        }
    }
    
    
    static func AlamofireUploadImageAtServer(url:String, completionHandler:@escaping([Course]) -> () ) {
        guard let url = URL(string: url), let image = UIImage(named: "me") else {return}
        let data = image.pngData()!
        
        let httpHeaders = HTTPHeaders(["Authorization" : "Client-ID 13cef97d61002c1"])
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "image")
        }, to: url, headers: httpHeaders).validate().responseJSON { (data) in
            
            switch data.result {
            
            case .success(let value):
             print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

}
}
