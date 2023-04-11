//
//  CatchViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 05.03.2023.
//

import UIKit
import CoreData

class CatchViewController: UIViewController {
    var monster: MonsterAnnotation?
    var monsterImage = UIImageView()
    var roomImage = UIImageView()
    let button = UIButton()
    let nameView = UIView()
    let nameLabel = UILabel()
    let levelLabel = UILabel()
    let messageView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let i = Int.random(in: 1...4)
        roomImage.image = UIImage(named: "Room"+String(i))
        roomImage.contentMode = .scaleAspectFill
        roomImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roomImage)
        NSLayoutConstraint.activate([
            roomImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomImage.topAnchor.constraint(equalTo: view.topAnchor),
            roomImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        button.setTitle("Попробовать поймать", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor(named: "WB")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            button.heightAnchor.constraint(equalToConstant: 55)
            
        ])
        button.addTarget(self, action: #selector(tryCatch), for: .touchUpInside)
        
        monsterImage.image = UIImage(named: monster?.name ?? "")
        monsterImage.contentMode = .scaleAspectFit
        monsterImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monsterImage)
        NSLayoutConstraint.activate([
            monsterImage.heightAnchor.constraint(equalToConstant: 150),
            monsterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monsterImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        monster?.level = Int.random(in: 5...20)
        nameLabel.text = monster?.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        levelLabel.text = "Уровень " + String(monster?.level ?? 0)
        
        view.addSubview(nameView)
        nameView.backgroundColor = UIColor(named: "WB")
        nameView.layer.cornerRadius = 10
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        nameView.addSubview(nameLabel)
        nameView.addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
            nameView.bottomAnchor.constraint(equalTo: monsterImage.topAnchor),
            nameView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            nameView.widthAnchor.constraint(equalToConstant: 125),
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: nameView.topAnchor, constant: 10),
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            levelLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 10),
            levelLabel.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: -10)
        ])
        
        messageView.isHidden = true
        titleLabel.text = "Не вышло:("
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        subLabel.text = "Попробуйте поймать еще раз!"
        subLabel.numberOfLines = 0
        subLabel.textAlignment = .center
        
        view.addSubview(messageView)
        messageView.backgroundColor = UIColor(named: "WB")
        messageView.layer.cornerRadius = 10
        messageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(titleLabel)
        messageView.addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            subLabel.widthAnchor.constraint(equalToConstant: 280),
            subLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func tryCatch() {
        button.isEnabled = false
        let probe = Int.random(in: 0...9)
        if probe>2 {
            let probe2 = Int.random(in: 0...9)
            if probe2 > 3 {
                messageView.isHidden = false
            } else {
                messageView.isHidden = false
                monsterImage.isHidden = true
                titleLabel.text = "Не вышло:("
                subLabel.text = "Монстр убежал"
                button.setTitle("Вернуться на карту", for: .normal)
                button.removeTarget(nil, action: nil, for: .touchUpInside)
                button.addTarget(self, action: #selector(back), for: .touchUpInside)
            }
        } else {
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            let context: NSManagedObjectContext = (appdelegate?.persistentContainer.viewContext)!
            let catchedMonster = Monsters.init(entity: NSEntityDescription.entity(forEntityName: "Monsters", in: context)!, insertInto: context)
            catchedMonster.name = monster?.name
            catchedMonster.level = Int16(monster?.level ?? 5)
            try? catchedMonster.managedObjectContext?.save()

            
            messageView.isHidden = false
            monsterImage.isHidden = true
            nameView.isHidden = true
            let newMonsterImage = UIImageView()
            let newNameView = UIView()
            let newNameLabel = UILabel()
            let newLevelLabel = UILabel()
            newMonsterImage.image = UIImage(named: monster?.name ?? "")
            newMonsterImage.contentMode = .scaleAspectFit
            newMonsterImage.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(newMonsterImage)
            view.addSubview(newNameView)
            NSLayoutConstraint.activate([
                newMonsterImage.heightAnchor.constraint(equalToConstant: 200),
                newMonsterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                newMonsterImage.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
                newNameView.bottomAnchor.constraint(equalTo: newMonsterImage.topAnchor)
            ])
            
            newNameLabel.text = monster?.name
            newNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            newLevelLabel.text = "Уровень " + String(monster?.level ?? 0)
            
            newNameView.backgroundColor = UIColor(named: "WB")
            newNameView.layer.cornerRadius = 10
            newNameView.translatesAutoresizingMaskIntoConstraints = false
            newNameLabel.translatesAutoresizingMaskIntoConstraints = false
            newLevelLabel.translatesAutoresizingMaskIntoConstraints = false
            newNameView.addSubview(newNameLabel)
            newNameView.addSubview(newLevelLabel)
            
            NSLayoutConstraint.activate([
                newNameView.bottomAnchor.constraint(equalTo: newMonsterImage.topAnchor),
                newNameView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
                newNameView.widthAnchor.constraint(equalToConstant: 125),
                newNameLabel.leadingAnchor.constraint(equalTo: newNameView.leadingAnchor, constant: 10),
                newNameLabel.topAnchor.constraint(equalTo: newNameView.topAnchor, constant: 10),
                newLevelLabel.topAnchor.constraint(equalTo: newNameLabel.bottomAnchor, constant: 10),
                newLevelLabel.leadingAnchor.constraint(equalTo: newNameView.leadingAnchor, constant: 10),
                newLevelLabel.bottomAnchor.constraint(equalTo: newNameView.bottomAnchor, constant: -10)
            ])
            
            titleLabel.text = "Ура!"
            subLabel.text = "Вы поймали монстра \(getNameInAccusativeCase(name: monster?.name)) в свою команду"
            button.setTitle("Перейти к карте", for: .normal)
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        button.isEnabled = true
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func getNameInAccusativeCase(name: String?) -> String {
        switch name {
        case "Сплюшка":
            return "Сплюшку"
        case "Гиппо":
            return "Гиппо"
        case "Вулканчик":
            return "Вулканчика"
        case "Зомбик":
            return "Зомбика"
        case "Драко":
            return "Драко"
        case "Щекан":
            return "Щекана"
        case "Желтухин":
            return "Желтухина"
        case "Болотник":
            return "Болотника"
        case "Уголёк":
            return "Уголька"
        case "Эмо":
            return "Эмо"
        default:
            return ""
        }
    }

}
