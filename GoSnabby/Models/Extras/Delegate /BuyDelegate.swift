//
//  BuyDelegate.swift
//  PorAquiRd
//
//  Created by apple on 1/6/21.
//

import Foundation
import UIKit

protocol AddDelegate {
    func addDelegateAction(type : Int)
}


protocol LocationDelegate {
    func LocationDelegateAction(pinInfo : Any)
}
