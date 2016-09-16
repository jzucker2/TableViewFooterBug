//
//  TestItem+CoreDataProperties.swift
//  UITableViewSectionFooterBug
//
//  Created by Jordan Zucker on 9/16/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import Foundation
import CoreData


extension TestItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestItem> {
        return NSFetchRequest<TestItem>(entityName: "TestItem");
    }

    @NSManaged public var title: String?
    @NSManaged public var creationDate: NSDate?

}
