//
//  ViewController.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 18.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        preload()
        setupView()
    }

    // MARK: - Private functionsx
    
    // Create a cell at the first run of app
    private func preload() {
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        
        if !isPreloaded {
            viewModel.createItem(text: "Simple task")
            defaults.set(true, forKey: "isPreloaded")
        }
    }
    
    private func setupView() {
        // TableView loading
        viewModel.getItems()
        
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
        let alert = UIAlertController(title: "Add tasks", message: "Enter a new task", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _  in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.viewModel.createItem(text: text)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            return
        }))
        present(alert, animated: true)
    }
}

// MARK: - Extansion setting TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.items[indexPath.row]
        let alert = UIAlertController(title: "Edit task", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _  in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.viewModel.editItem(item: model, text: text)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            return
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle  == .delete {
            tableView.beginUpdates()
            viewModel.deleteItem(item: viewModel.items[indexPath.row])
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}
