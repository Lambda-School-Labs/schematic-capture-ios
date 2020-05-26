//
//  ClientsViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox
import CoreData

class ClientsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    var tableView: UITableView!
    var headerView = HeaderView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Properties
    
    var user: User?
    var clients = [Client]()
    var projectController = ProjectController()
    var dropboxController = DropboxController()
    
    var token: String? {
        didSet {
            fetchClients()
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "clientId", ascending: true),
                                         NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "clientId", cacheName: nil)
        
        frc.delegate = self as! NSFetchedResultsControllerDelegate
        
        do {
            try frc.performFetch() // Fetch the tasks
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dropboxController.authorizeClient(viewController: self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Clients", style: .plain, target: nil, action: nil)
        fetchClients()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        self.title = "Schematic Capture"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(goToSettings))
        navigationController?.navigationBar.tintColor = .label
        
        // Update the headerView when a user id set
        headerView.setup(viewTypes: .clients, value: [
            (user?.firstName ?? ""), "Clients"
        ])
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        
        indicator.startAnimating()
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    
    func fetchClients() {
        // Get the token when the user LogIn or get it from UserDefault.
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }
        projectController.getClients(token: token) { result in
            if let clients = try? result.get() as? [Client] {
                DispatchQueue.main.async {
                    self.clients = clients
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func goToSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

// MARK: TableView Delegate/Datasource

extension ClientsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell {
            let client = fetchedResultsController.object(at: indexPath)
            cell.updateViews(viewTypes: .clients, value: client)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let client = self.clients[indexPath.row]
        let projectsTableViewViewController = ProjectsTableViewController()
        projectsTableViewViewController.projectController = projectController
        projectsTableViewViewController.dropboxController = dropboxController
        projectsTableViewViewController.client = client
        projectsTableViewViewController.token = token
        navigationController?.pushViewController(projectsTableViewViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

extension ClientsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
