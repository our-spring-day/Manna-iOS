//
//  MannaSection.swift
//  Manna-iOS
//
//  Created by once on 2020/06/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxDataSources

struct MannaSection {
    var status: String
    var items: [Item]
    
    init(status: String, items: [Item]) {
        self.status = status
        self.items = items
    }
}

extension MannaSection: SectionModelType {
    typealias Item = Manna
        
    init(original: MannaSection, items: [Item]) {
        self = original
        self.items = items
    }
    var identity: String {
        return status
    }
}
