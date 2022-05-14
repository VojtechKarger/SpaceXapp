//
//  GaleryView.swift
//  SpaceXapp
//
//  Created by vojta on 10.04.2022.
//
import Combine
import UIKit

class GaleryView: BaseCollectionView<UIImage,GaleryCell> {
    
    weak var viewModel: DetailViewModel? = nil
        
    override func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let height = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    func configure(data: [UIImage], viewModel: DetailViewModel) {
        self.viewModel = viewModel
        updateData(data: data)
        
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        self.viewModel?.imagesPublisher
            .sink{ images in
                self.updateData(data: images.map { $0.image })
            }.store(in: &cancellables)
    }
}
