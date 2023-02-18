//
//  ToDo+CoreDataProperties.swift
//  ListTest
//
//  Created by Soyombo Mantaagiin on 18.02.2023.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var title: String?
    @NSManaged public var creationDate: Date?

}

extension ToDo : Identifiable {

}
