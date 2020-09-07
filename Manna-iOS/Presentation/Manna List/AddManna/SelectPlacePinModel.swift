//
//  SelectPlacePinModel.swift
//  Manna-iOS
//
//  Created by once on 2020/09/07.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift

class SelectPlacePinModel {
    let network: AddressFetchable
    
    init(network: AddressFetchable = AddressAPI()) {
        self.network = network
    }
    
    func getAddress(_ lng: Double, _ lat: Double) -> Observable<Result<[Address], Error>> {
        return network.getAddress(lng, lat)
    }
}
