import UIKit
import CreateViaryFeature
import EditViaryFeature
import Wireframe
import ViaryListFeature
import SwiftUI

struct AppRouter: Router {

    func destinate<S>(_ routing: S.Type, destination: S.Destination) -> AnyView where S : Routing {
        if let destination = destination as? ViaryList.Destination {
            switch destination {
            case .createViary:
                return AnyView(CreateViaryRouting().make(input: ()))
            case .viaryDetail(let viary):
                return AnyView(EditViaryRouting().make(input: .init(viary: viary)))
            }
        }
        return AnyView(EmptyView())
    }
}
