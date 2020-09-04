//
//  CouterViewReactor.swift
//  TestProject
//
//  Created by KTH on 2020/09/04.
//  Copyright © 2020 KTH. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class CounterViewReactor: Reactor {
    
    enum Action { //사용자 입력
        case increase
        case decrease
    }
    
    enum Mutation { //State를 바꾸는 가장 작은 단위
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    struct State { //현재값을 저장
        var value: Int = 0
        var isLoading: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .increase:
            
            return Observable.concat([ //직렬로 수행
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue)
                    .delay(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.init()),
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue)
                    .delay(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.init()),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    //          이전상태,         뮤테이션            -> 다음상태
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state //새로운 상태를 만듦
        
        switch mutation {
            
        case .increaseValue:
            newState.value += 1
            
        case .decreaseValue:
            newState.value -= 1
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        
        return newState //새로운 상태 반환
    }
}
