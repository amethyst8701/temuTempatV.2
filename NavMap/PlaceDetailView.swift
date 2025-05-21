//
//  PlaceDetailView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 15/05/25.
//

import SwiftUI

struct PlaceDetailView: View {
    var place: Place
    var onClose: () -> Void
    var onDismiss: () -> Void
    var onGetDirections: (Place) -> Void
    @State private var showingIndoorDirection = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Spacer()
                
                Text(place.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.secondary)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 16)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Scroll content
            ScrollView {
                VStack(spacing: 16) {
                    Image(place.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(16)
                        .clipped()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    HStack(spacing: 16) {
                        DirectionButton(
                            title: "Outdoor Direct",
                            icon: "arrow.triangle.turn.up.right.circle.fill",
                            isActive: true,
                            action: { onGetDirections(place) }
                        )
                        
                        DirectionButton(
                            title: "Indoor Direct",
                            icon: "arrow.triangle.turn.up.right.circle.fill",
                            isActive: false,
                            action: { showingIndoorDirection = true }
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Details")
                            .font(.title3)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            DetailRow(icon: "mappin.circle.fill", title: "Address", content: place.address)
                            Divider()
                            if place.hours != "nil" && place.hours != "Always available" {
                                DetailRow(icon: "clock.fill", title: "Hours", content: place.hours)
                                Divider()
                            }
                            DetailRow(icon: "tag.fill", title: "Tags", content: place.tags.joined(separator: ", "))
                            Divider()
                            DetailRow(icon: "text.alignleft", title: "Description", content: place.description)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $showingIndoorDirection) {
            IndoorDirectionView(
                destination: place,
                onGoPressed: { startingPoint in
                    print("Selected starting point: \(startingPoint)")
                }
            )
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct DirectionButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isActive ? .white : .gray)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? Color.blue : Color.gray.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isActive ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isActive ? Color.blue.opacity(0.2) : .clear, radius: 8, y: 4)
        }
    }
}

#Preview {
    PlaceDetailView(
        place: Place.greenEatery,
        onClose: {},
        onDismiss: {},
        onGetDirections: { _ in }
    )
}
