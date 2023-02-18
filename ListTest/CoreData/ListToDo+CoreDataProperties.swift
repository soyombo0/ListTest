//
//  ListToDo+CoreDataProperties.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 19.02.2023.
//
//

import Foundation
import CoreData


extension ListToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListToDo> {
        return NSFetchRequest<ListToDo>(entityName: "ListToDo")
    }

    @NSManaged public var text: String?

}

extension ListToDo : Identifiable {

}
