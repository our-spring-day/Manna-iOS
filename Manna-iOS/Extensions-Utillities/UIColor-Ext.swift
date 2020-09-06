//
//  UIColor-Ext.swift
//  Manna-iOS
//
//  Created by once on 2020/09/06.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

enum AssetsColor {
  case megaBoxColor
  case defaultGrayColor
  case divisionLineColor
  case selectedCellMintColor
  case selectedCellGrayColor
  case darkBgColor
  case banksaladColor
}

extension UIColor {
  static func appColor(_ name: AssetsColor) -> UIColor {
    switch name {
    case .megaBoxColor:
      return #colorLiteral(red: 0.2392156863, green: 0.1215686275, blue: 0.5568627451, alpha: 1)
    case .defaultGrayColor:
      return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    case .divisionLineColor:
      return #colorLiteral(red: 0.7744807005, green: 0.7698782086, blue: 0.7780196071, alpha: 1)
    case .selectedCellMintColor:
      return #colorLiteral(red: 0.3098039216, green: 0.7137254902, blue: 0.7607843137, alpha: 1)
    case .selectedCellGrayColor:
      return #colorLiteral(red: 0.9384746552, green: 0.9328956604, blue: 0.9427630305, alpha: 1)
    case .darkBgColor:
      return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    case .banksaladColor:
      return #colorLiteral(red: 0.3802058101, green: 0.7672194839, blue: 0.6821649075, alpha: 1)
    }
  }
}
