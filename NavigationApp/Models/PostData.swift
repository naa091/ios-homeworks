//
//  PostData.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 03.11.2024.
//

struct PostData {
    let author: String?
    let description: String?
    let nameImage: String? = nil
    let likes: Int? = nil
    let views: Int? = nil
    
    static func getMockData(count: Int) -> [PostData] {
        var mockData: [PostData] = []
        
        for item in 1...count {
            let postData = PostData(
                author: "Author: \(item)",
                description: "Decription: \(item)"
            )
            
            mockData.append(postData)
        }
        
        return mockData
    }
}

