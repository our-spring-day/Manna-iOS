//
//  AddMannaViewModel.swift
//  Manna-iOS
//
//  Created by once on 2020/06/09.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift

protocol AddMannaViewModelInput {
    var manna: AnyObserver<String> { get }
}

protocol AddMannaViewModelOutput {

}

protocol AddMannaViewModelType {
    var inputs: AddMannaViewModelInput { get }
    var outputs: AddMannaViewModelOutput { get }
}

class AddMannaViewModel: AddMannaViewModelInput, AddMannaViewModelOutput, AddMannaViewModelType {
    let disposeBag = DisposeBag()
    
    let manna: AnyObserver<String>
    
    init() {
        let mannaInput = PublishSubject<String>()
        var arr: [Any] = []
        manna = mannaInput.asObserver()
        
        mannaInput
            .take(4)
            .window(timeSpan: 1000, count: 4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (observable) in
                observable
                    .subscribe { (str) in
                        arr.append(str)
                        print(arr)
                }
                }, onCompleted: {
                    print("complete")
            })
            .disposed(by: disposeBag)
    }
    
    var outputs: AddMannaViewModelOutput { return self }
    var inputs: AddMannaViewModelInput { return self }
}
