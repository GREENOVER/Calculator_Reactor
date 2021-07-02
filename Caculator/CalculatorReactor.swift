import Foundation
import ReactorKit
import RxSwift

final class CalculatorReactor: Reactor {
    // 버튼에 따른 연산 케이스
    enum Operation {
        case operation((Decimal, Decimal) -> Decimal)
        case sign((Decimal) -> Decimal)
        case percent((Decimal) -> Decimal)
        case result
    }
    
    // 뷰 버튼 인터랙션에 따른 액션
    enum Action {
        case inputNumber(String)
        case inputDot(String)
        case operation(Operation)
        case clear
    }
    
    enum Mutation {
        case number(String)
        case dot(String)
        case operation(Operation)
        case clear
    }
    
    struct State {
        var displayResult: String = ""
    }
    
    // State 초기화 상수 선언
    let initialState: State = State()
    
    // Action -> Mutation 스트림 변환
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputNumber(let number):
            return Observable.just(Mutation.number(number))
        case .inputDot(let dot):
            return Observable.just(Mutation.dot(dot))
        case .operation(let operation):
            return Observable.just(Mutation.operation(operation))
        case .clear:
            return Observable.just(Mutation.clear)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        <#code#>
    }
    
}
