//
//  MockNetworker.swift
//  SpaceXappUITests
//
//  Created by vojta on 14.05.2022.
//

import Foundation
import UIKit

class MockNetworking: Networker {
    
    let successfull: Bool
    let sleepTime: TimeInterval
    
    init(successfull: Bool, sleepTime: TimeInterval = .zero) {
        self.successfull = successfull
        self.sleepTime = sleepTime
    }
    
    func getFlightsData(_ completion: @escaping (Result<[Flight], NetworkingError>) -> ()) {
        var flights: [Flight] = []
        
        for i in 10..<31 {
            let flight: Flight = .init(name: "flight number \(i)", date: "2020-05-30T19:22:00.000Z", images: [], id: "Flight\(i)")
            flights.append(flight)
        }
         
        let successfull = successfull
        DispatchQueue.main.asyncAfter(deadline: .now()  + sleepTime) {
            if successfull {
                completion(.success(flights))
            }else {
                let errors: [NetworkingError] = [.decodingError, .requestError]
                completion(.failure(errors.randomElement()!))
            }
        }
    }
    
    func fetchImagefrom(_ url: URL, _ completion: @escaping (Result<Data, NetworkingError>) -> ()) {
        let mockImage = UIImage(named: "MockImage")!
        
        guard let data = mockImage.pngData() else {
            completion(.failure(.decodingError))
            return
        }
        
        let successfull = successfull
        DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
            
            if successfull {
                completion(.success(data))
            }else {
                let errors: [NetworkingError] = [.errorFetchingImage, .requestError]
                completion(.failure(errors.randomElement()!))
            }
        }
    }
    
    func getCrewMember(with id: String, _ completion: @escaping (Result<Crew, NetworkingError>) -> ()) {
        
    }
}

