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

    // MARK: - Private functionsx
    private func setupView() {
        // TableView loading
        viewModel.getItems()
        
        // View Settingsv 
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
            self?.viewModel.createItem(text: text)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
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
        let sheet = UIAlertController(title: "Edit item", message: nil, preferredStyle: .alert)
        sheet.addTextField(configurationHandler: nil)
        sheet.addAction(UIAlertAction(title: "Edit", style: .cancel, handler: { [weak self] _  in
            guard let field = sheet.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.viewModel.editItem(item: model, text: text)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        present(sheet, animated: true)
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
