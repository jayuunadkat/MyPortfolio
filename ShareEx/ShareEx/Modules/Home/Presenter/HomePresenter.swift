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
}
