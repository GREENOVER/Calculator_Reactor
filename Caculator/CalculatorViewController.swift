import UIKit
import ReactorKit
import RxSwift
import RxCocoa


class CalculatorViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    
    @IBOutlet weak var acButton: UIButton!
    
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    
    func bind(reactor: CalculatorReactor) {
        self.acButton.rx.tap
            .map { .clear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.signButton.rx.tap
            .map { .operation }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

}
