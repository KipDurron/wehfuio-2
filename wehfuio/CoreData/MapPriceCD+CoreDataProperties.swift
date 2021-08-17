//
//  MapPriceCD+CoreDataProperties.swift
//  wehfuio
//
//  Created by Илья Кадыров on 02.06.2021.
//
//

import Foundation
import CoreData


extension MapPriceCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPriceCD> {
        return NSFetchRequest<MapPriceCD>(entityName: "MapPriceCD")
    }

    @NSManaged public var destination: City?
    @NSManaged public var origin: City?
    @NSManaged public var departure: Date?
    @NSManaged public var returnDate: Date?
    @NSManaged public var numberOfChanges: Int32
    @NSManaged public var value: Int32
    @NSManaged public var distance: Int32
    @NSManaged public var actual: Bool

}

extension MapPriceCD : Identifiable {

}
