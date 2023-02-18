//
//  ViewModel.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 18.02.2023.
//

import UIKit

class ViewModel: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [ListToDo]()
    
    func getItems() {
        do {
            items = try context.fetch(ListToDo.fetchRequest())
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func createItem(text: String) {
        let newItem = ListToDo(context: context)
        newItem.text = text
        
        do {
            try context.save()
            getItems()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(item: ListToDo) {
        context.delete(item)
        
        do {
            try context.save()
            getItems()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func editItem(item: ListToDo, text: String) {
        item.text = text
        
        do {
            try context.save()
            getItems()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
