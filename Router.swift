//
//  Router.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import Foundation

enum Router {
    case menu
    case intro
    case intro2
    case armor
    case weapon
    case instruction
    case instruction2
    case instruction3
    case battle
    case end
}

class AppRouter: ObservableObject {
    @Published var router: Router = .menu
}

