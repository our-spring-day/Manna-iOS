//
//  SelectPlaceModel.swift
//  Manna-iOS
//
//  Created by once on 2020/09/03.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation
import RxSwift

class SelectPlaceModel {
    let addressNetwork: AddressFetchable
    
    init(addressNetwork: AddressFetchable = AddressAPI()) {
        self.addressNetwork = addressNetwork
    }
    
    func getAdress(_ address: String) -> Observable<Result<[Address], Error>> {
        return addressNetwork.getAddress2(address)
    }
}
