//
//  SearchProtocol.swift
//  Manna-iOS
//
//  Created by 정재인 on 2020/06/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol  Type {
    var searchValue: BehaviorRelay<String> { get }
}
