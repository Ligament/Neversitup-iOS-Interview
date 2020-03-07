//
//  Customers.swift
//  neversitup pretest
//
//  Created by Amornthap on 7/3/2563 BE.
//  Copyright © 2563 Ligament Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Customers)
public class Customers: NSManagedObject {

}

extension Customers: Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customers> {
        return NSFetchRequest<Customers>(entityName: "Customers")
    }
    
    @NSManaged public var id: String
    @NSManaged public var name: String
}
