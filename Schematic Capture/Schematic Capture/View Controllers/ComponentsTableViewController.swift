//
//  ComponentsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentsTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Propertiess
    
    var projectController: ProjectController?
    var token: String?
    var jobSheet: JobSheetRepresentation? {
        didSet {
            fetchComponents()
            guard let name = jobSheet?.name else { return }
            headerView.setup(viewTypes: .jobsheets, value: [name, "Job Sheets"])
        }
    }
    var components = [Component]()
    var filteredComponents = [Component]()
    
    //var pdfBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComponents()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        tableView?.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
    }
    
    // MARK: - Functions
    
    private func fetchComponents() {
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        components.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
        
        if headerView.searchBar.text != "" {
            let component = components[indexPath.row]
            cell.updateViews(viewTypes: .components, value: component)
        } else {
            let component = components[indexPath.row]
            cell.updateViews(viewTypes: .components, value: component)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let components = self.components[indexPath.row]
//        let expyTableViewViewController = ComponentsTableViewController()
//        expyTableViewViewController.projectController = projectController
//        expyTableViewViewController.jobSheet = jobSheet
//        expyTableViewViewController.token = token
        //navigationController?.pushViewController(expyTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
}

extension ComponentsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        //self.filteredComponents =  self.components.filter({($0.componentDescription .capitalized.contains(didChangeText.capitalized))}) else { return }
        tableView.reloadData()
    }
}













