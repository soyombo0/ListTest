//
//  ViewModel.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 18.02.2023.
//

import UIKit

class ViewModel: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [ToDo]()
     
    func getItems() {
        do {
            items = try context.fetch(ToDo.fetchRequest())
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func createItem(title: String) {
        let newItem = ToDo(context: context)
        newItem.title = title
        newItem.creationDate = Date()
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(item: ToDo) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func editItem(item: ToDo, title: String) {
        item.title = title
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
