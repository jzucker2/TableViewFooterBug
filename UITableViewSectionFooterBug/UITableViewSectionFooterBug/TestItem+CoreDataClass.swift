//
//  TestItem+CoreDataClass.swift
//  UITableViewSectionFooterBug
//
//  Created by Jordan Zucker on 9/16/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import Foundation
import CoreData

@objc(TestItem)
public class TestItem: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = NSDate()
    }

}
