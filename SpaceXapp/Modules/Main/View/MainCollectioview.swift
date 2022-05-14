//
//  MainCollectioview.swift
//  SpaceXapp
//
//  Created by vojta on 04.05.2022.
//

import Foundation
import UIKit
import Combine

class MainCollectionView: BaseView {
    lazy var collectionView: UICollectionView = {
        var view: UICollectionView = .init(frame: .zero, collectionViewLayout: createLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dataSource: MainCollectionViewDatasource!
    
    var cancellables: Set<AnyCancellable> = []
    
    weak var viewModel: MainViewModel? = nil
    
    override init() {
        super.init()
        
        collectionView.register(MainCollectionViewHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainCollectionViewHeaderView.reuseIdentifier)
        
        setupDataSource()
        
        NotificationCenter.default.addObserver(forName: .changedOrientation, object: nil, queue: nil) { _ in
            self.collectionView.setCollectionViewLayout(self.createLayout(), animated: true)
        }
    }
    
    func configure(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        self.viewModel?.searchCollectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.updateData(data, for: .main)
            }
            .store(in: &cancellables)
        
        self.viewModel?.featuredFlightPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
                guard let data = data else { return }
                self.updateData([data], for: .featured)
            })
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        addSubview(collectionView)
    }
    
    override func addConstraints() {
        collectionView.sameConstrainghts(as: self)
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func setupDataSource() {
        dataSource = .init()
                
        let cellRegistration: UICollectionView.CellRegistration<MainCollectionViewCell, Flight.ID> = .init{ cell, indexPath, flightID  in
            
            guard let flight = self.dataSource.flightData[flightID] else { return }
            //checking if the flight object has images in it
            //if not than adding default image with SpaceX logo
            if let link = flight.links.images.original.first {
                //checking if we had already downloaded this image
                if let image = ImageStorage.shared.getImage(for: link) {
                    cell.mainImageView.image = image
                }else{
                    //sets placeholder as current image of the cell
                    cell.mainImageView.image = UIImage(named: "placeholder")!
                    self.viewModel?.downloadImage(from: link) {
                        self.dataSource.reloadItems(id: flight.id)
                    }
                }
            }else{
                let size = UIScreen.main.bounds.size
                
                let image = UIImage(named: "SpaceXLogo")!
                    .scalePreservingAspectRatio(targetSize: size)
                cell.mainImageView.image = image
            }
            
            if let atrStr = highlight(self.viewModel?.searchText ?? "", in: flight.name) {
                cell.nameLabel.attributedText = atrStr
                //cell.nameLabel.text = nil
            }else {
                cell.nameLabel.text = flight.name
                //cell.nameLabel.attributedText = nil
            }

            cell.dateLabel.text = flight.formatedDate
        }
        
        dataSource.datasource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        dataSource.datasource?.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            let header: MainCollectionViewHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MainCollectionViewHeaderView.reuseIdentifier,
                for: indexPath) as! MainCollectionViewHeaderView
        
            let section = MainSection.getSection(for: indexPath.section)
            header.label.text = section.rawValue
            header.label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            return header
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 10.0
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: UIDevice.current.orientation == .portrait ? .fractionalWidth(1.0): .fractionalHeight(1.0)
        )
        
        let count = UIDevice.current.orientation == .portrait ? 1 : 2
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: count
        )
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind:  UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func updateData(_ data: [Flight], for section: MainSection.Identifier) {
        dataSource.updateData(for: section, data: data)
    }
}
