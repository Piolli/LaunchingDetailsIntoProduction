//
//  DataLoaderTests.swift
//  DataLoaderTests
//
//  Created by Александр Камышев on 23.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import XCTest
@testable import LaunchingDetailsIntoProduction

class DataLoaderTests: XCTestCase {
    
    var loader: DataLoader!

    override func setUp() {
        loader = DataLoader.sharedInstance
    }

    override func tearDown() {
        loader = nil
    }
    
    func test_loadFromFile_exitsts_success() {
        let filePath = "/Users/alexander/Desktop/details_data_1.txt"
        let expectedDetails: [Detail] = [
        .init(1, timeOnMachines: [1, 2, 3]),
        .init(2, timeOnMachines: [4, 5, 6]),
        .init(3, timeOnMachines: [7, 8, 9]),
        ]
        
        let string = loader.readAll(file: filePath)
        XCTAssertNotNil(string)
        
        let details = loader.parse(string: string!)
        XCTAssertEqual(details.count, 3)
        
        XCTAssertEqual(details, expectedDetails)
    }


}

extension Detail : Equatable {
    public static func == (lhs: Detail, rhs: Detail) -> Bool {
        return lhs.number == rhs.number && lhs.timeOnMachines == rhs.timeOnMachines && lhs.color == rhs.color
    }
}
