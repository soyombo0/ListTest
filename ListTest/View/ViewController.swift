//
//  ViewController.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 18.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var viewModel = ViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private functions
    private func setupView() {
        
        // View Settings
        title = "To Do List"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTap))
        
        // TableView settings
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func onTap() {
        let alert = UIAlertController(title: "Add Item", message: "Enter a new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .cancel, handler: { [weak self] _  in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.viewModel.createItem(title: text)
            self?.viewModel.getItems()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}
