import SwiftUI

struct IndoorDirectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLocation: StartingPoint?
    let onGoPressed: (StartingPoint) -> Void
    
    enum StartingPoint: String, CaseIterable {
        case appleAcademy = "Apple Developer Academy"
        case halteBreeze = "Halte The Breeze"
        case halteSML = "Halte SML Plaza"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Starting Point Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Starting Point")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 24)
                        
                        Text("Choose the location you're near from")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        // Radio Button Options
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(StartingPoint.allCases, id: \.self) { point in
                                RadioButton(
                                    title: point.rawValue,
                                    isSelected: selectedLocation == point
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedLocation = point
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 32)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Go Button
                    VStack {
                        Divider()
                        Button(action: {
                            if let location = selectedLocation {
                                onGoPressed(location)
                                dismiss()
                            }
                        }) {
                            Text("Go")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedLocation != nil ? Color.blue : Color.gray.opacity(0.3))
                                        .shadow(color: selectedLocation != nil ? Color.blue.opacity(0.3) : .clear, radius: 8, y: 4)
                                )
                        }
                        .disabled(selectedLocation == nil)
                        .padding(24)
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Indoor Direction")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .font(.title2)
                    }
                }
            }
        }
    }
}

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Custom Radio Button Circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
} 