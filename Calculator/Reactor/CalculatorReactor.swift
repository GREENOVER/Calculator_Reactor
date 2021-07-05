import Foundation
import ReactorKit

final class CalculatorReactor: Reactor {
  // MARK: 버튼에 따른 연산 케이스
  enum Operation {
    case operation((Decimal, Decimal) -> Decimal)
    case sign((Decimal) -> Decimal)
    case percent((Decimal) -> Decimal)
    case result
  }
  
  // MARK: 뷰 버튼 인터랙션에 따른 액션
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
  
  // MARK: 뷰 상태 클래스
  struct State {
    var displayText: String = "0"
    fileprivate var resultNum: Decimal = 0
    fileprivate var operation: Operation?
    fileprivate var inputText: String = "0"
    
    fileprivate var inputNum: Decimal {
      let value = Decimal(string: inputText)
      
      if value != 0 {
        return value!
      }
      
      return resultNum
    }
  }
  
  // MARK: State 초기화 상수 선언
  let initialState: State = State()
  
  // MARK: Action -> Mutation 스트림 변환
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
  
  // MARK: 이전 Mutation 상태 받아 다음 상태 반환
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .number(let number):
      state.inputText.append(number)
      state.inputText = checkPrefixNum(state.inputText)
      state.displayText = state.inputText
      
    case .dot(let dot):
      state.inputText.append(dot)
      state.inputText = checkPrefixNum(state.inputText)
      state.inputText = checkDot(state.inputText)
      state.displayText = state.inputText
      
    case .operation(let operation):
      switch operation {
      case .operation:
        state.operation = operation
        state.resultNum = state.inputNum
        state.inputText = "0"
      case .sign(let sign):
        if var temp =  Decimal(string: state.inputText) {
          temp += state.resultNum
          state.resultNum = 0
          state.inputText = String("\(sign(temp))")
          state.displayText = state.inputText
        }
      case .percent(let percent):
        if var temp =  Decimal(string: state.inputText) {
          temp += state.resultNum
          state.resultNum = 0
          state.inputText = String("\(percent(temp))")
          state.displayText = state.inputText
        }
      case .result:
        if case let .operation(operation) = state.operation {
          state.resultNum = operation(state.resultNum, state.inputNum)
          state.inputText = "0"
          state.operation = nil
        }
        state.displayText = String("\(state.resultNum)")
      }
    case .clear:
      state.inputText = "0"
      state.displayText = "0"
      state.resultNum = 0
      state.operation = nil
    }
    return state
  }
  
  // MARK: 입력 숫자 첫 요소 검증
  fileprivate func checkPrefixNum(_ text: String) -> String {
    var inputText = text
    if !(inputText.contains(".")) && inputText.hasPrefix("0") {
      inputText.removeFirst()
    }
    return inputText
  }
  
  // MARK: 중복 소수점 검증 및 제거
  fileprivate func checkDot(_ text: String) -> String {
    var inputText = text
    let dot = inputText.filter{ $0 == "." }
    if dot.count > 1 {
      inputText.remove(at: inputText.lastIndex(of: ".")!)
    }
    return inputText
  }
}
