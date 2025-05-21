import SwiftUI

struct NavigationStepsView: View {
    let startingPoint: IndoorDirectionView.StartingPoint
    let destination: Place
    @Environment(\.dismiss) private var dismiss
    
    var navigationPath: NavigationPath? {
        NavigationPath.getPath(from: startingPoint, to: destination)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if let path = navigationPath {
                        // Destination Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("To: \(destination.name)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("From: \(startingPoint.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        
                        // Navigation Steps
                        ForEach(path.steps) { step in
                            NavigationStepCell(step: step)
                            
                            if step.id != path.steps.last?.id {
                                // Distance indicator
                                HStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 2)
                                        .padding(.leading, 35)
                                    
                                    Text("\(step.distance)m")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                                .frame(height: 32)
                            }
                        }
                    } else {
                        // No path found view
                        VStack(spacing: 16) {
                            Image(systemName: "map")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No route available")
                                .font(.headline)
                            Text("We couldn't find a route from \(startingPoint.rawValue) to \(destination.name)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(.horizontal)
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

struct NavigationStepCell: View {
    let step: NavigationStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Direction Icon
                Image(systemName: step.direction.iconName)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.instruction)
                        .font(.headline)
                    
                    Text(step.subInstruction)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Step Image
            Image(step.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStepsView(
        startingPoint: .appleAcademy,
        destination: Place.greenEatery
    )
} 