//
//  MonsterTableViewCell.swift
//  final_project
//
//  Created by Екатерина Вишневская on 05.03.2023.
//

import UIKit

class MonsterTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    var nameLabel = UILabel()
    var levelLabel = UILabel()
    var image = UIImageView()
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addAndConfigureImage()
        addAndConfigureLabels()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func addAndConfigureLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textColor = .white
        contentView.addSubview(levelLabel)
        
    }
    
    private func addAndConfigureImage() {
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            image.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            levelLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
    }

}
