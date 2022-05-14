//
//  DetailViewModel.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import Foundation
import Combine
import UIKit

final class DetailViewModel: BaseViewModel<Flight>,
                             ObservableObject {
    
    //Propeties
    @Published var name: String = ""
    @Published var detail: String = ""
    @Published var failiureText: String = ""
    @Published var dateString: String = ""
    @Published var images: [ImageObject] = []
    
    @Published var crew: [Crew] = []
    
    var imagesPublisher: Published<[ImageObject]>.Publisher { $images }
    var crewPublisher: Published<[Crew]>.Publisher { $crew }
    
    weak var coordinator: DetailCoordinator?
    
    var id: String = ""
    
    let networker: Networker
    
    init(networker: Networker) {
        self.networker = networker
    }
    
    override func configure(data: Flight) {
        
        name = data.name
        if let success = data.success {
            failiureText = success ? "succesfull mission" : "mission failed"
        }else{
            failiureText = "currently running mission"
        }
        detail = data.details ?? "no details...."
        dateString = data.formatedDate
        
        id = data.id
        
        downloadImages(links: data.links.images.original)
        getCrew(ids: data.crew)
    }
    
    private func downloadImages(links: [String]) {
        guard !links.isEmpty else {
            let defaultImg = UIImage(named: "SpaceXLogo")!
                .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
            images.append(ImageObject(id: UUID().uuidString, image: defaultImg))
            return
        }
        
        for link in links {
            if let image = ImageStorage.shared.getImageObject(for: link) {
                images.append(image)
            }else{
                let url = URL(string: link)!
                networker.fetchImagefrom(url) { res in
                    switch res {
                    case.success(let data):
                        if let image = UIImage(data: data)?
                            .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size) {
                            ImageStorage.shared.store(image, for: link)
                            self.images.append(ImageObject(id: UUID().uuidString, image: image))
                        }
                    case .failure(let err):
                        log(err)
                    }
                }
            }
        }
    }
    
    func getCrew(ids: [String]) {
        for id in ids {
            networker.getCrewMember(with: id) { res in
                switch res {
                case.success(let member):
                    self.getImage(for: member)
                case .failure(let err):
                    log(err)
                }
            }
        }
    }
    
    private func getImage(for member: Crew) {
        let link = member.image
        
        if ImageStorage.shared.getImage(for: link) != nil {
            self.crew.append(member)
        } else {
            let url = URL(string: link)!
            networker.fetchImagefrom(url) { res in
                switch res {
                case.success(let data):
                    guard let image = UIImage(data: data)?
                        .scalePreservingAspectRatio(targetSize: CGSize(width: 200, height: 200))
                    else { return }
                    ImageStorage.shared.store(image, for: link)
                    self.crew.append(member)
                case .failure(let err):
                    log(err)
                }
            }
        }
    }
}
