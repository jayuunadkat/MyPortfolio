//
//  HomePresenter.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    func refresh()
    func donateIntent(for user: User)
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    let interactor: HomeInteractorProtocol

    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
    }

    func refresh() {
        listUsers()
    }

    private func listUsers() {
        let users = interactor.listUsers()
        view?.showList(users)
    }

    func donateIntent(for user: User) {
        interactor.donateIntent(for: user.id.uuidString, name: user.title)
    }
}
