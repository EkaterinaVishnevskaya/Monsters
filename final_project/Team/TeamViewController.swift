//
//  TeamViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 05.03.2023.
//

import UIKit
import CoreData

class TeamViewController: UIViewController {
    var tableView = UITableView()
    var label = UILabel()
    
    private let persistentContainer = NSPersistentContainer(name: "final_project")
    private lazy var fetchedResultsController: NSFetchedResultsController<Monsters> = {
        let fetchRequest = Monsters.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        title = "Моя команда"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .systemBlue
        let image = UIImageView(image: UIImage(named: "Background2"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы еще не поймали монстров в свою команду"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.register(MonsterTableViewCell.self, forCellReuseIdentifier: "Monsters")
        tableView.dataSource = self
        persistentContainer.loadPersistentStores() { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to load persistent store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                }
                catch {
                    print(error)
                }
            }
        }
    }
}

extension TeamViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let n = sections[section].numberOfObjects
            if n == 0 {
                tableView.isHidden = true
                label.isHidden = false
            } else {
                tableView.isHidden = false
                label.isHidden = true
            }
            return n
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Monsters", for: indexPath) as! MonsterTableViewCell
        let monster = fetchedResultsController.object(at: indexPath)
        cell.nameLabel.text = monster.name!
        cell.levelLabel.text = "Уровень \(monster.level)"
        cell.image.image = UIImage(named: monster.name!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let monster = fetchedResultsController.object(at: indexPath)
            persistentContainer.viewContext.delete(monster)
            try? persistentContainer.viewContext.save()
        }
    }
}

extension TeamViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        case .move:
            if let newIndexPath = newIndexPath {
                if let indexPath = indexPath {
                    tableView.moveRow(at: indexPath, to: newIndexPath)
                    tableView.reloadData()
                }
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        @unknown default:
            fatalError()
        }
    }
}
