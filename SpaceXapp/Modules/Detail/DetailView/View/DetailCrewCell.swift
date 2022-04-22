//
//  DetailCrewCell.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

final class DetailCrewCell: BaseCell<Crew> {

    static let identifier = "CrewCell"
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .top
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .headline)
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var agencyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .callout)
        view.textAlignment = .center
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    override func configure(data: Crew) {
        nameLabel.text = data.name
        agencyLabel.text = data.agency
        imageView.image = ImageStorage.shared.getImage(for: data.image) ?? UIImage(named: "placeholder")!
    }
    
    override func addViews() {
        addSubview(nameLabel)
        addSubview(agencyLabel)
        addSubview(imageView)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -70),
            imageView.widthAnchor.constraint(equalTo: heightAnchor, constant: -70),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            agencyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            agencyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            agencyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }
}
