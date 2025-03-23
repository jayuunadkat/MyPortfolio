//
//  HomeInteractor.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import Foundation
protocol HomeInteractorProtocol: AnyObject {
    func listUsers() -> [User]
}

class HomeInteractor: HomeInteractorProtocol {
    func listUsers() -> [User] {
        return [
            User(title: "John Doe"),
            User(title: "Jane Smith"),
            User(title: "Michael Johnson"),
            User(title: "Sarah Connor"),
            User(title: "Alex Martinez"),
            User(title: "Emily Davis"),
            User(title: "James Lee"),
            User(title: "Olivia Brown"),
            User(title: "Daniel Wilson"),
            User(title: "Sophia Taylor"),
            User(title: "Ethan Clark"),
            User(title: "Isabella Harris"),
            User(title: "Matthew Lewis"),
            User(title: "Mia Young"),
            User(title: "David Walker"),
            User(title: "Charlotte Allen"),
            User(title: "Liam Scott"),
            User(title: "Amelia King"),
            User(title: "Benjamin Adams"),
            User(title: "Sophie Carter"),
            User(title: "Oliver Mitchell"),
            User(title: "Lucas Green"),
            User(title: "Ava Nelson"),
            User(title: "Mason Perez"),
            User(title: "Grace Hall"),
            User(title: "Noah Cooper"),
            User(title: "Chloe Baker"),
            User(title: "Jack Reed"),
            User(title: "Victoria Morris"),
            User(title: "Henry Evans")
        ]
    }
}
