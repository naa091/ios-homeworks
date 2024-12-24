//
//  PostData.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.12.2024.
//

public struct PostData {
    public let author: String?
    public let description: String?
    public let nameImage: String? = nil
    public let likes: Int? = nil
    public let views: Int? = nil
    
    public static func getMockData(count: Int) -> [PostData] {
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
