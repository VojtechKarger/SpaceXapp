//
//  DetailCrewView.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

final class DetailCrewViewController: BaseCollectionView<Crew, DetailCrewCell> {
    
    weak var viewModel: DetailViewModelProtocol?
    
    func configure(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
                
        viewModel.crewPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { crew in
                self.updateData(data: crew)
            }).store(in: &cancellables)
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        //layout.estimatedItemSize = CGSize(width: 200, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        return layout
    }

}
