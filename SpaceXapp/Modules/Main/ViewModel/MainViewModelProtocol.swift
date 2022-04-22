//
//  MainViewModelProtocol.swift
//  SpaceXapp
//
//  Created by vojta on 30.03.2022.
//

import UIKit
import Combine

protocol MainViewModelProtocol: BaseViewModel<Any> {
    
    var filterByImagePublisher: Published<Bool>.Publisher { get }
    
    var searchCollectionPublisher: Published<[Flight]>.Publisher { get }
    
    var searchCollectionOfFlights: [Flight] { get set }
    
    var filterByImage: Bool { get set }
    
    var sorted: ComparisonResult { get set }
    
    var coordinator: MainCoordinator? { get set }
        
    func search(text: String)
    
    func bind()
        
    func clearSearch()
    
    func downloadImage(from link: String, completion: @escaping() -> Void)
    
    func presentDetail(flight: Flight, fromFrame: CGRect, imageFrame: CGRect)
    
    func updateData(sort: Bool)
    
    func handleRefresh(_ completion: @escaping()-> Void)
    
    func setInitialData()
}
