//
//  PetrovSokolycinTests.swift
//  PetrovSokolycinTests
//
//  Created by Александр Камышев on 23.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import XCTest
@testable import LaunchingDetailsIntoProduction

class PetrovSokolycinTests: XCTestCase {

    func testPetrovSokolycin1() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]), //the same first item
            .init(2, timeOnMachines: [4, 1]), //the same first item
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]),
        ]
        
        let reorderedItems = PetrovSokolitsyn.PetrovSokolitsyn1(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [5, 1, 2, 4, 3])
//        do i need to use another recomendations for resolve item position?
//        XCTAssertEqual(numbers, [5, 2, 1, 4, 3])
    }
    
    func testPetrovSokolycin2() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]),
            .init(2, timeOnMachines: [4, 1]),
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]),
        ]
        
        let reorderedItems = PetrovSokolitsyn.PetrovSokolitsyn2(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [4, 1, 3, 5, 2])
    }
    
    func testPetrovSokolycin3() {
        let items: [Detail] = [
            .init(1, timeOnMachines: [4, 5]), //the same diff
            .init(2, timeOnMachines: [4, 1]),
            .init(3, timeOnMachines: [30, 4]),
            .init(4, timeOnMachines: [6, 30]),
            .init(5, timeOnMachines: [2, 3]), //the same diff
        ]
        
        let reorderedItems = PetrovSokolitsyn.PetrovSokolitsyn3(items: items)
        let numbers = reorderedItems.map( { $0.number } )
        
        XCTAssertEqual(numbers, [4, 1, 5, 2, 3])

//      do i need to use another recomendations for resolve item position?
//      XCTAssertEqual(numbers, [4, 5, 1, 2, 3])
    }

}
