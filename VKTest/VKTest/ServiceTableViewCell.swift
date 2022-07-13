//
//  File.swift
//  VKTest
//
//  Created by Сергей Николаев on 13.07.2022.
//

import Foundation
import UIKit
import Kingfisher
import PinLayout

class ServiceTableViewCell: UITableViewCell {
    weak var mainViewController: ServicesViewController?
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let imgService = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth = mainViewController!.view.frame.width
        
        titleLabel.pin
            .top(12)
            .left(90)
            .height(40)
            .width(screenWidth - 140)
            .sizeToFit(.width)
        
        descriptionLabel.pin
            .top(39)
            .left(90)
            .height(40)
            .width(screenWidth - 140)
            .sizeToFit(.width)
        
        imgService.pin
            .top(12)
            .left(12)
            .height(65)
            .width(65)
    }
    
    private func setup() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .left
        
        [titleLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.addSubview(imgService)
    }
    
    func config(with service: Service) {
        titleLabel.text = service.name
        descriptionLabel.text = service.description
        imgService.kf.setImage(with: URL(string: service.icon_url), placeholder: nil, options: nil, completionHandler: nil)
    }
}
