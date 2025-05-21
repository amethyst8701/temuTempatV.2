//
//  Place.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 18/05/25.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Equatable, Hashable {
    let id: String // Using String ID for easier dictionary lookup
    let name: String
    let address: String
    let imageName: String
    let tags: [String]
    let hours: String
    let description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable conformance
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

extension Place {
    static let greenEatery = Place(
        id: "green_eatery",
        name: "Green Eatery Canteen",
        address: "Lt. B Gedung GOP 9",
        imageName: "Green Eatery",
        tags: ["Food", "Drink", "GOP 9"],
        hours: "Always available",
        description: "The GOP 9 Canteen, better known as Green Eatery, is located in the basement of Green Office Park 9 in BSD City, offering a comfy and affordable dining spot for employees and visitors.",
        latitude: -6.302072012617987,
        longitude: 106.65252618491591
    )
    
    static let starbucks = Place(
        id: "starbucks",
        name: "Starbucks GOP 9",
        address: "Ground Floor GOP 9",
        imageName: "Starbucks",
        tags: ["Coffee", "Drink", "GOP 9"],
        hours: "07:00 - 20:00",
        description: "Starbucks at GOP 9 serves premium coffee and beverages in a modern setting.",
        latitude: -6.301663,
        longitude: 106.654311
    )
    
    static let arabica = Place(
        id: "arabica",
        name: "%Arabica GOP 9",
        address: "Ground Floor GOP 9",
        imageName: "Arabica",
        tags: ["Coffee", "Drink", "GOP 9"],
        hours: "08:00 - 19:00",
        description: "%Arabica brings its signature minimalist design and high-quality coffee to GOP 9.",
        latitude: -6.301608,
        longitude: 106.653157
    )
}

