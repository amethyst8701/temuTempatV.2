//
//  MapContainerView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 15/05/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapContainerView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var mapSelection: Place?
    let places: [Place]
    let route: MKRoute?
    let onPlaceSelected: (Place) -> Void
    @State private var selectedAnnotation: Place?
    
    struct MarkerStyle {
        let icon: String
        let color: Color
        
        static func forTag(_ tag: String) -> MarkerStyle {
            switch tag.lowercased() {
            case "food":
                return MarkerStyle(icon: "fork.knife", color: .orange)
            case "drink":
                return MarkerStyle(icon: "mug.fill", color: .teal)
            case "toilet":
                return MarkerStyle(icon: "toilet", color: .gray)
            case "mushola":
                return MarkerStyle(icon: "house", color: .indigo)
            case "entertainment":
                return MarkerStyle(icon: "film", color: .purple)
            case "pharmacy":
                return MarkerStyle(icon: "cross.case", color: .mint)
            case "market":
                return MarkerStyle(icon: "cart.fill", color: .green)
            case "coffee":
                return MarkerStyle(icon: "cup.and.heat.waves.fill", color: .brown)
            case "work":
                return MarkerStyle(icon: "laptopcomputer", color: .blue)
            case "atm":
                return MarkerStyle(icon: "creditcard.fill", color: .blue)
            default:
                return MarkerStyle(icon: "mappin", color: .red)
            }
        }
    }
    
    func getMarkerStyle(for place: Place) -> MarkerStyle {
        // Get the first matching tag style, or default if none match
        return place.tags.lazy
            .map { MarkerStyle.forTag($0) }
            .first ?? MarkerStyle(icon: "mappin", color: .red)
    }

    struct CustomAnnotation: View {
        let place: Place
        let style: MarkerStyle
        let isSelected: Bool
        let onTap: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                // Main marker circle
                ZStack {
                    Circle()
                        .fill(style.color)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: style.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                }
                
                // Marker point
                Triangle()
                    .fill(style.color)
                    .frame(width: 16, height: 8)
            }
            .shadow(color: .black.opacity(0.2), radius: isSelected ? 6 : 3, y: isSelected ? 3 : 1)
            .scaleEffect(isSelected ? 1.3 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
            .onTapGesture(perform: onTap)
        }
    }
    
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()
            return path
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            ForEach(places) { place in
                let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                let style = getMarkerStyle(for: place)
                
                Annotation(place.name, coordinate: coordinate, anchor: .bottom) {
                    CustomAnnotation(
                        place: place,
                        style: style,
                        isSelected: place == mapSelection,
                        onTap: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                if mapSelection == place {
                                    mapSelection = nil
                                } else {
                                    mapSelection = place
                                    onPlaceSelected(place)
                                }
                            }
                        }
                    )
                }
                .tag(place)
            }
            
            // User location
            UserAnnotation()
            
            // Route if available
            if let route {
                MapPolyline(route)
                    .stroke(Color.blue, lineWidth: 4)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .tint(.blue)
    }
} 
