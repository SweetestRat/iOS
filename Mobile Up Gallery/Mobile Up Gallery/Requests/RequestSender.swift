//
//  RequestSender.swift
//  Mobile Up Gallery
//
//  Created by Владислава Гильде on 04.04.2022.
//

import UIKit
import VK_ios_sdk

final class RequestSender {
        
    private let alert = UIAlertController(title: "Something wrong", message: "", preferredStyle: .alert)
    private var photos: [String]! = []
    
    func getPhotosData(callback: @escaping ([Photo]) -> Void) {
        
        let METHOD = "photos.get"
        let PARAMS = "owner_id=-128666765&album_id=266276915"
        let API_VERSION = "5.131"
        guard let TOKEN = UserDefaults.standard.string(forKey: "token") else { return }
        
        guard let url = URL(string: "https://api.vk.com/method/\(METHOD)?\(PARAMS)&access_token=\(TOKEN)&v=\(API_VERSION)") else { return }

        let photosData = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                self.alert.message = error?.localizedDescription
                self.alert.present(self.alert, animated: true, completion: {})
                return
            }
            
            let photos = parsePhotosData(data: data)
            callback(photos)
        }
        
        photosData.resume()
    }
    
    private func parsePhotosData(data: Data) -> [Photo] {
        
        var photos: [Photo] = []
        
        do {
            
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return [] }
            
            guard let response = jsonObject["response"] as? [String: Any] else { return [] }
            guard let items = response["items"] as? NSArray else { return [] }
            
            for jsonItem in items {
                guard
                    let json = jsonItem as? [String: Any],
                    let photoDate = json["date"] as? Double,
                    let photoCharacteristics = json["sizes"] as? NSArray
                else {
                    print("Invalid JSON format")
                    return []
                }
                
                    guard
                        let char = photoCharacteristics[8] as? [String: Any],
                        let photoUrl = char["url"] as? String,
                        let height = char["height"] as? Int,
                        let width = char["width"] as? Int
                    else {
                        print("Invalid JSON format")
                        return []
                    }

                    photos.append(Photo(url: photoUrl, date: photoDate, height: height, width: width))
            }
            
            return photos
           
        } catch {
            print("! JSON parsing error" + error.localizedDescription)
            return []
        }
    }
    
}
