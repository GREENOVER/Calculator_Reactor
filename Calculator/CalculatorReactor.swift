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
  
  class State {
    var displayText: String = "0"
    var resultNum: Decimal = 0
    var operation: Operation?
    var inputText: String = ""
    
    var inputNum: Decimal {
      guard let inputValue = Decimal(string:inputText) else {
        return resultNum
      }
      return inputValue
    }
    
    func checkPrefixNum() {
      if !(inputText.contains(".")) && inputText.hasPrefix("0") {
        inputText.removeFirst()
      }
    }
    
    func checkDot() {
      let dot = inputText.filter{ $0 == "." }
      if dot.count > 1 {
        inputText.remove(at: inputText.lastIndex(of: ".")!)
      }
    }
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
  
  // 이전 Mutation 상태 받아 다음 상태 반환
  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .number(let number):
      state.inputText.append(number)
      state.checkPrefixNum()
      state.displayText = state.inputText
    case .dot(let dot):
      state.inputText.append(dot)
      state.checkPrefixNum()
      state.checkDot()
      state.displayText = state.inputText
    case .operation(let operation):
      break
    case .clear:
      state.inputText = ""
      state.displayText = ""
      state.operation = nil
    }
    
    return state
  }
}
