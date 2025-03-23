//
//  HomeRouter.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let interactor: HomeInteractorProtocol = HomeInteractor()
        var presenter: HomePresenterProtocol = HomePresenter(interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
