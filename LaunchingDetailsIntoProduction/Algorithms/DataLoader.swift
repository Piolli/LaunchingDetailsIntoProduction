//
//  DataLoader.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 23.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

/// Loads and parses file' data into `Detail` struct
class DataLoader {
    
    static let sampleFileData =
    """
    4 5
    4 1
    30 4
    6 30
    2 3
    """
    
    public static let sharedInstance = DataLoader()
    
    private init() { }
    
    func readAll(file: String) -> String? {
        return try? String(contentsOfFile: file)
    }
    
    func parse(string: String) -> [Detail] {
        var details: [Detail] = []
        let rows = string.split(separator: "\n")
        
        for i in 0..<rows.count {
            let timeOnMachines = rows[i].split(separator: " ").map({ CGFloat(Int($0)!) })
            let detail = Detail(i+1, timeOnMachines: timeOnMachines)
            details.append(detail)
        }
        
        return details
    }
    
}
