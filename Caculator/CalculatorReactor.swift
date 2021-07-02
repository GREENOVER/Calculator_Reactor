import Foundation
import ReactorKit
import RxSwift

final class CalculatorReactor: Reactor {
    enum Action {
        case operation
        case inputNumber
        case clear
    }
    
    enum Mutation {
        case setFollowing(Bool)
    }
    
    struct State {
        var isFollowing: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputNumber:
            return
        case .operation:
            return
        case .clear:
            return
        }
    }
    
}
