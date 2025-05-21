//
//  PlaceListView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 08/05/25.
//

import SwiftUI

struct PlaceListView: View {
    let places: [Place]
    @Binding var searchText: String
    @Binding var selectedPlace: Place?
    @Binding var isSheetPresented: Bool
    var onPlaceSelected: (Place) -> Void
    var onGetDirections: (Place) -> Void
    var onClearRoute: () -> Void
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        } else {
            return places.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if let place = selectedPlace {
                    PlaceDetailView(
                        place: place,
                        onClose: {
                            withAnimation(
                                .spring(
                                    response: 0.5,
                                    dampingFraction: 0.9,
                                    blendDuration: 0.3
                                )
                            ) {
                                selectedPlace = nil
                                onClearRoute()
                            }
                        },
                        onDismiss: {
                            withAnimation {
                                isSheetPresented = false
                            }
                        },
                        onGetDirections: onGetDirections
                    )
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition
                                .opacity
                                .combined(with: .move(edge: .bottom))
                                .animation(
                                    .spring(
                                        response: 0.5,
                                        dampingFraction: 0.9,
                                        blendDuration: 0.3
                                    )
                                ),
                            removal: AnyTransition
                                .opacity
                                .combined(with: .move(edge: .bottom))
                                .animation(
                                    .spring(
                                        response: 0.5,
                                        dampingFraction: 0.9,
                                        blendDuration: 0.3
                                    )
                                )
                        )
                    )
                } else {
                    VStack(spacing: 16) {
                        Capsule()
                            .fill(Color.secondary.opacity(0.4))
                            .frame(width: 40, height: 5)
                            .padding(.top, 8)
                        
                        HStack {
                            Text(!searchText.isEmpty ? searchText.capitalized : "Recommendation")
                                .font(.headline).bold()
                            
                            Spacer()
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        searchText = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20))
                                }
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(filteredPlaces) { place in
                                    HStack(spacing: 16) {
                                        Image(place.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(16)
                                            .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(place.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            
                                            Text(place.tags.joined(separator: ", "))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "mappin.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.blue)
                                                Text(place.address)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            if place.hours != "nil" && place.hours != "Always available" {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "clock.fill")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.blue)
                                                    Text(place.hours)
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(24)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    .onTapGesture {
                                        withAnimation(
                                            .spring(
                                                response: 0.5,
                                                dampingFraction: 0.9,
                                                blendDuration: 0.3
                                            )
                                        ) {
                                            selectedPlace = place
                                            onPlaceSelected(place)
                                            onClearRoute()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                    .background(Color.white)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

