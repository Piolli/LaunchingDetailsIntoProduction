//
//  Detail.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 22.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

struct Detail {
    
    let number: Int
    var color: UIColor = .white
    var leftOffset: CGFloat = 0
    
    //First item – first machine
    let timeOnMachines: [CGFloat]
    
    init(_ number: Int, timeOnMachines: [CGFloat]) {
        self.number = number
        self.timeOnMachines = timeOnMachines
    }
    
}
