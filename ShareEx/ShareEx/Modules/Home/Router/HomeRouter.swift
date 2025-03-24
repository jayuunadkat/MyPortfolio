//
//  HomeRouter.swift
//  ShareEx
//
//  C`reated by Jaymeen Unadkat on 23/03/25.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let intentService: IntentServiceProtocol = IntentService()
        let interactor: HomeInteractorProtocol = HomeInteractor(intentService: intentService)
        var presenter: HomePresenterProtocol = HomePresenter(interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
