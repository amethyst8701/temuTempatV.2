//
//  PlaceAnnotationView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 15/05/25.
//

import SwiftUI

struct PlaceAnnotationView: View {
    let place: Place
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Image(systemName: place.name.contains("Apple") ? "laptopcomputer" : "cup.and.heat.waves")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(isSelected ? .pink : .white)
            .frame(width: 20, height: 20)
            .padding(7)
            .background(isSelected ? .white : .pink)
            .clipShape(Circle())
            .shadow(radius: isSelected ? 3 : 0)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
            .onTapGesture(perform: onTap)
    }
}
