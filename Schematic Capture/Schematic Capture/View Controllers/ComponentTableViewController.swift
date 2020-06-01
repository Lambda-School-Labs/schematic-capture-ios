//
//  ComponentsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox

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
    var dropboxController: DropboxController?
    
    var token: String?
    
    var jobSheet: JobSheetRepresentation? {
        didSet {
            fetchComponents()
        }
    }
    var components = [ComponentRepresentation]()
    var filteredComponents: [ComponentRepresentation]?
    
    var imagePicker: ImagePicker!
    
    //var pdfBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        tableView?.register(ComponentTableViewCell.self, forCellReuseIdentifier: ComponentTableViewCell.id)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    // MARK: - Functions
    
    private func fetchComponents() {
        guard let id = jobSheet?.id, let token = self.token ?? UserDefaults.standard.string(forKey: .token) else { return }
        projectController?.getComponents(with: id, token: token, completion: { (results) in
            if let components = try? results.get() as? [ComponentRepresentation] {
                print("COMPONENTS IN VIEWCONTROLLER: ", components) 
                self.components = components
                DispatchQueue.main.async {
                    let incompletedComponentsCount = components.filter({!($0.image != nil)}).count
                    let totalCount = components.count
                    guard let name = self.jobSheet?.name else { return }
                    self.headerView.setup(viewTypes: .components, value: [name, "Incomplete (\(incompletedComponentsCount)/\(totalCount))", "Components",])
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        })
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if headerView.searchBar.text != "" {
            return filteredComponents?.count ?? 0
        } else if components.count == 0 {
            tableView.setEmptyView(title: "You don't have any job sheets.", message: "You'll find your assigned job sheets here.")
            return 0
        } else {
            tableView.restore()
            return components.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComponentTableViewCell.id, for: indexPath) as? ComponentTableViewCell else { return UITableViewCell() }
        if headerView.searchBar.text != "" {
            if let component = filteredComponents?[indexPath.row] {
                cell.updateViews(component: component)
            }
        } else {
            let component = components[indexPath.row]
            cell.updateViews(component: component)
        }
        cell.dropboxController = dropboxController
        cell.componentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let component = self.components[indexPath.row]
        let componentDetailsViewController = ComponentDetailsViewController()
        componentDetailsViewController.component = component
        navigationController?.pushViewController(componentDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    
    @objc func showImagePicker() {
        self.imagePicker.present(from: view)
    }
}

// MARK: - ImagePickerDelegate

extension ComponentsTableViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            let annotationViewController = AnnotationViewController()
            annotationViewController.imageDoneEditingDelegate = self
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            annotationViewController.image = image
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - ImageDoneEditingDelegate

extension ComponentsTableViewController: ImageDoneEditingDelegate {
    
    func ImageDoneEditing(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: 1) else { return }
        if let indexPath = tableView.indexPathForSelectedRow, let client = dropboxController?.client {
            let component = self.components[indexPath.row]
            client.files.createFolderV2(path: "Test two", autorename: false)
        }
    }
}

extension ComponentsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        self.filteredComponents = components.filter({($0.componentApplication!.capitalized.contains(didChangeText.capitalized))})
        tableView.reloadData()
    }
}














