//
//  SpaceXappTests.swift
//  SpaceXappTests
//
//  Created by vojta on 14.05.2022.
//

import XCTest
@testable import SpaceXapp
import Combine

class SpaceXappTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchTest() throws {
        let networker = MockNetworking(successfull: true)
        let viewModel = MainViewModel(networker: networker)
        
        viewModel.filterByImage = false
        viewModel.setInitialData()
        
        viewModel.search(text: "15")
        
        XCTAssert(viewModel.searchCollectionOfFlights[0].name == "flight number 15", "search not working")
    }
    
    func testExample() throws {
        let expectation = self.expectation(description: "setInitialData")

        var cancellables: Set<AnyCancellable> = []
        let networking = Networking()
        let viewModel = MainViewModel(networker: networking)
        
        viewModel.setInitialData()
        
        viewModel.searchCollectionPublisher.sink { flights in
            if !flights.isEmpty {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 7.0)
        XCTAssert(!viewModel.searchCollectionOfFlights.isEmpty, "setInitialData not working! \(viewModel.searchCollectionOfFlights)")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
