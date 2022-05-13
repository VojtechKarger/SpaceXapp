//
//  MainCollectionViewDatasource.swift
//  SpaceXapp
//
//  Created by vojta on 03.05.2022.
//

import UIKit

struct MainSection: Identifiable {
    var id: Identifier
    
    var posts: [Flight.ID]
    
    static func getSection(for index: Int) -> Identifier {
        switch index {
        case 0: return .featured
        case 1: return .main
        default: fatalError("section not implemented!")
        }
    }
    
    enum Identifier: String, CaseIterable {
        case featured = "Featured"
        case main = "Main"
    }
}

final class MainCollectionViewDatasource {
    
    var datasource: UICollectionViewDiffableDataSource<MainSection.ID,Flight.ID>? = nil
    private var snapshot: NSDiffableDataSourceSnapshot<MainSection.ID, Flight.ID> = .init()
    
    var flightData: [Flight.ID: Flight] = [:]
    var sections: [MainSection.ID: MainSection] = [:]
    
    init() {
        setInitialData()
    }
    
    func setInitialData() {
        snapshot.appendSections(MainSection.Identifier.allCases)
        
        for sectionType in MainSection.ID.allCases {
            if let items = sections[sectionType]?.posts {
                snapshot.appendItems(items, toSection: sectionType)
            }
            sections[sectionType] = MainSection(id: sectionType, posts: [])
        }
        
        datasource?.apply(snapshot, animatingDifferences: true)
    }
 
    func reloadItems(id: Flight.ID) {
        snapshot.reloadItems([id])
        
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    func returnItem(for indexPath: IndexPath) -> Flight? {
        guard let section = sections[MainSection.getSection(for: indexPath.section)] else { fatalError("section not implemented!") }
        let postID = section.posts[indexPath.item]
        return flightData[postID]
    }
    
    func updateData(for section: MainSection.ID, data: [Flight]) {
        if let items = sections[section]?.posts {
            snapshot.deleteItems(items)
        }
        
        snapshot.appendItems(data.map{ $0.id }, toSection: section)
        
        data.forEach { flight in
            flightData[flight.id] = flight
        }

        sections[section]?.posts = data.map{ $0.id }
        
        datasource?.apply(snapshot, animatingDifferences: true)
    }
}
