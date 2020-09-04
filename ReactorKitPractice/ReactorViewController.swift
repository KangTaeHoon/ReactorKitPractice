//
//  ReactorViewController.swift
//  TestProject
//
//  Created by KTH on 2020/08/28.
//  Copyright © 2020 KTH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class ReactorViewController: UIViewController, StoryboardView { //렌더링만 담당

    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = CounterViewReactor()
    }
    
    func bind(reactor: CounterViewReactor) {

        //Action
        increaseButton.rx.tap  //버튼이 눌리면
            .map { Reactor.Action.increase } //액션으로 바꿔서
            .bind(to: reactor.action) //리엑터에 전달
            .disposed(by: disposeBag)
        
        // 1. 뮤테이트 실행
        // 2. 리듀스 실행
        // 3. 새로운 상태가 뷰로 전달
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //State
        reactor.state
            .map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
    

}
