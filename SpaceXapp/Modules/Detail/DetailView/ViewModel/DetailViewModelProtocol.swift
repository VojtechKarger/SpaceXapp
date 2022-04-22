//
//  DetailViewModelProtocol.swift
//  SpaceXapp
//
//  Created by vojta on 30.03.2022.
//

import Foundation

protocol DetailViewModelProtocol: BaseViewModel<Flight> {
    
    var name: String { get set }
    var detail: String { get set }
    var failiureText: String { get set }
    var dateString: String { get set }
    var images: [ImageObject] { get set }
    
    var imagesPublisher: Published<[ImageObject]>.Publisher { get }
    var crewPublisher: Published<[Crew]>.Publisher { get }
    
    var crew: [Crew] { get set }
    var coordinator: DetailCoordinator? { get set }
    
    var id: String { get set }

    func configure(data: Flight)
}

