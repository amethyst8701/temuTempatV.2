//
//  LocationSearchView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 16/05/25.
//

import SwiftUI
import MapKit

struct Category: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
}

struct LocationSearchView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var isShowingBottomSheet: Bool
    @ObservedObject var mapViewModel: MapViewModel
    var places: [Place]
    var onPlaceSelected: (Place) -> Void
    var onCategorySelected: (String) -> Void
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return []
        } else {
            return places.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                SearchBarView(searchText: $searchText) {
                    // When user hits enter/search, close LocationSearchView and show PlaceList
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = false  // Close LocationSearchView
                        isShowingBottomSheet = true  // Show PlaceList
                    }
                }
                
                Button("Cancel") {
                    withAnimation {
                        searchText = ""
                        isSearching = false
                        isShowingBottomSheet = true // Restore bottom sheet when canceling
                    }
                }
                .foregroundColor(.primary)
            }
            .padding(.top, 8)
            
            Divider()
                .padding(.top, 12)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Recents View
                    if !mapViewModel.recentPlaces.isEmpty {
                        Text("Recents View")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        ForEach(mapViewModel.recentPlaces) { place in
                            Button(action: {
                                onPlaceSelected(place)
                                isSearching = false
                                isShowingBottomSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(width: 24)
                                    
                                    Image(place.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(4)
                                        .padding(.horizontal, 4)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(place.name)
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                        Text(place.tags.joined(separator: ", ").lowercased())
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                    }
                    
                    // Find Nearby
                    Text("Find Nearby")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(nearbyCategories) { category in
                            Button(action: {
                                searchText = category.name
                                onCategorySelected(category.name)
                                isSearching = false
                                isShowingBottomSheet = true
                            }) {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(category.color)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: category.icon)
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                        )
                                    
                                    Text(category.name)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

let nearbyCategories: [Category] = [
    Category(icon: "fork.knife", name: "Food", color: .orange),
    Category(icon: "mug.fill", name: "Drink", color: .teal),
    Category(icon: "cart.fill", name: "Market", color: .green),
    Category(icon: "toilet", name: "Toilet", color: .gray),
    Category(icon: "house", name: "Mushola", color: .indigo),
    Category(icon: "cross.case", name: "Pharmacy", color: .mint),
    Category(icon: "cup.and.heat.waves.fill", name: "Coffee", color: .brown),
    Category(icon: "creditcard.fill", name: "ATM", color: .blue),
    Category(icon: "film", name: "Entertainment", color: .purple),
    Category(icon: "graduationcap.fill", name: "Education", color: .red)
]


