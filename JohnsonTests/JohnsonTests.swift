//
//  JohnsonTests.swift
//  JohnsonTests
//
//  Created by Александр Камышев on 22.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import XCTest
@testable import LaunchingDetailsIntoProduction

class JohnsonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testJhonson1() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]),
            .init(2, timeOnMachines: [4, 1]),
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]),
        ]
        
        let reorderedItems = Johnson.Johnson1(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [5, 1, 2, 4, 3])
    }
    
    func testJhonson2() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]),
            .init(2, timeOnMachines: [4, 1]),
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]),
        ]
        
        let reorderedItems = Johnson.Johnson2(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [4, 1, 3, 5, 2])
    }
    
    func testJhonson3() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [2, 10, 5, 7, 1]),
            .init(2, timeOnMachines: [5, 1, 8, 5, 10]),
            .init(3, timeOnMachines: [3, 5, 10, 2, 3]),
            .init(4, timeOnMachines: [7, 7, 4, 4, 5]),
            .init(5, timeOnMachines: [9, 3, 1, 10, 7]),
            .init(6, timeOnMachines: [4, 8, 3, 1, 4]),
            .init(7, timeOnMachines: [1, 2, 9, 8, 2]),
            .init(8, timeOnMachines: [8, 9, 2, 6, 11])
        ]
        
        let reorderedItems = Johnson.Johnson3(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [2, 8, 5, 7, 3, 1, 6, 4])
        print(reorderedItems)
        print(numbers)
    }
    
    func testJhonson4() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]),
            .init(2, timeOnMachines: [4, 1]),
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]),
        ]
        
        let reorderedItems = Johnson.Johnson4(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [4, 3, 1, 5, 2])
    }

    func testJhonson5() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [2, 10, 5, 7, 1]),
            .init(2, timeOnMachines: [5, 1, 8, 5, 10]),
            .init(3, timeOnMachines: [3, 5, 10, 2, 3]),
            .init(4, timeOnMachines: [7, 7, 4, 4, 5]),
            .init(5, timeOnMachines: [9, 3, 1, 10, 7]),
            .init(6, timeOnMachines: [4, 8, 3, 1, 4]),
            .init(7, timeOnMachines: [1, 2, 9, 8, 2]),
            .init(8, timeOnMachines: [8, 9, 2, 6, 11])
        ]
        
        let reorderedItems = Johnson.Johnson5(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [2, 8, 5, 7, 3, 1, 4, 6])
    }

}
