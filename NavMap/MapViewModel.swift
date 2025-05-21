//
//  MapViewModel.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 15/05/25.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var cameraPosition: MapCameraPosition = .region(.init(
        center: .init(latitude: -6.302370, longitude: 106.652059),
        latitudinalMeters: 300,
        longitudinalMeters: 300
    ))
    @Published var mapSelection: Place?
    @Published var route: MKRoute?
    @Published var recentPlaces: [Place] = []
    private let maxRecentPlaces = 3
    
    let locationManager = CLLocationManager()
    
    init() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addToRecents(_ place: Place) {
        // Remove if already exists
        recentPlaces.removeAll { $0.id == place.id }
        
        // Add to beginning
        recentPlaces.insert(place, at: 0)
        
        // Keep only the three most recent places
        if recentPlaces.count > maxRecentPlaces {
            recentPlaces = Array(recentPlaces.prefix(maxRecentPlaces))
        }
    }
    
    func selectPlace(_ place: Place) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            mapSelection = place
            
            // Animate camera to selected place
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: .init(
                        latitude: place.latitude,
                        longitude: place.longitude
                    ),
                    latitudinalMeters: 300,
                    longitudinalMeters: 300
                )
            )
        }
    }
    
    func clearRoute() {
        route = nil
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            let update = try await updates.first { $0.location?.coordinate != nil }
            return update?.location?.coordinate
        } catch {
            print("Cannot get user location")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .walking
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                DispatchQueue.main.async {
                    self.route = directions.routes.first
                    
                    // If we have a route, adjust the camera to show the entire route
                    if let route = self.route {
                        // Get the bounding rectangle of the route
                        let rect = route.polyline.boundingMapRect
                        
                        // Calculate paddings (more padding at the bottom for the sheet)
                        let horizontalPadding = 0.3 // 30% padding on sides
                        let topPadding = 0.3 // 30% padding on top
                        let bottomPadding = 1.5 // 100% padding on bottom for sheet
                        
                        // Calculate new height and y position with asymmetric padding
                        let newHeight = rect.size.height * (1 + topPadding + bottomPadding)
                        let newY = rect.origin.y - (rect.size.height * topPadding)
                        
                        // Calculate new width and x position
                        let newWidth = rect.size.width * (1 + horizontalPadding * 2)
                        let newX = rect.origin.x - (rect.size.width * horizontalPadding)
                        
                        // Create the padded rect
                        let paddedRect = MKMapRect(
                            x: newX,
                            y: newY,
                            width: newWidth,
                            height: newHeight
                        )
                        
                        // Animate to the new camera position
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.cameraPosition = .rect(paddedRect)
                        }
                    }
                }
            } catch {
                print("Show error")
            }
        }
    }
}

