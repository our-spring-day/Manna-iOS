//
//  MannaProvider.swift
//  Manna-iOS
//
//  Created by once on 2020/06/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MannaProvider {
    private static let mannaRelay = BehaviorRelay<[MannaSection]>(value:
        [ MannaSection(status: "시작전", items: []),
         MannaSection(status: "약속중", items: []),
         MannaSection(status: "종료", items: []) ]
    )
    
    private static let mannaObservable = mannaRelay.asObservable()
        .subscribeOn(MainScheduler.instance)
        .share(replay: 1, scope: .whileConnected)
    
    static func addManna(data: Manna) {
        var mannaValue = self.mannaRelay.value
        mannaValue[0].items.append(data)
        mannaRelay.accept(mannaValue)
    }
    
    static func observable() -> Observable<[MannaSection]> {
        return mannaObservable
            .map { $0 }
            .share(replay: 1, scope: .whileConnected)
    }
}
