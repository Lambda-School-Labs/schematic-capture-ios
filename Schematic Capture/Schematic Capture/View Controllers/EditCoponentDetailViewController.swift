//
//  EditCoponentDetailViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 22.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class EditCoponentDetailViewController: UIViewController {
    
    var value: String?
    
    var textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        title = value
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
