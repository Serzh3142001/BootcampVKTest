//
//  Service.swift
//  VKTest
//
//  Created by Сергей Николаев on 13.07.2022.
//

import Foundation

struct Request: Codable {
    let body: Body
    
    struct Body: Codable {
        let services: [Service]
    }
}

struct Service: Codable {
    let name: String
    let description: String
    let link: String
    let icon_url: String
}
