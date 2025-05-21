//
//  NavigationStep.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 18/05/25.
//

import Foundation

struct NavigationStep: Identifiable {
    let id = UUID()
    let direction: Direction
    let instruction: String
    let subInstruction: String
    let distance: Int // in meters
    let image: String // image name
    
    enum Direction: String {
        case turnLeft = "Turn Left"
        case turnRight = "Turn Right"
        case goDown = "Go Down"
        case goUp = "Go Up"
        case goStraight = "Go Straight"
        
        var iconName: String {
            switch self {
            case .turnLeft: return "arrow.turn.up.left"
            case .turnRight: return "arrow.turn.up.right"
            case .goDown: return "arrow.down"
            case .goUp: return "arrow.up"
            case .goStraight: return "arrow.up"
            }
        }
    }
}

// Navigation paths for each starting point and destination combination
struct NavigationPath {
    let startingPoint: IndoorDirectionView.StartingPoint
    let destination: Place
    let steps: [NavigationStep]
}

// Sample navigation paths
extension NavigationPath {
    static func getPath(from startingPoint: IndoorDirectionView.StartingPoint, to destination: Place) -> NavigationPath? {
        // First try to get a specific path if it exists
        if let specificPath = paths[destination.id]?.first(where: { $0.startingPoint == startingPoint }) {
            return specificPath
        }
        
        // If no specific path exists, return a default path
        return getDefaultPath(from: startingPoint, to: destination)
    }
    
    // Default path generator for places without specific navigation data
    private static func getDefaultPath(from startingPoint: IndoorDirectionView.StartingPoint, to destination: Place) -> NavigationPath {
        NavigationPath(
            startingPoint: startingPoint,
            destination: destination,
            steps: [
                NavigationStep(
                    direction: .turnLeft,
                    instruction: "Turn Left",
                    subInstruction: "from the \(startingPoint.rawValue)",
                    distance: 50,
                    image: "ADA_Step 1" // You can use a default placeholder image
                ),
                NavigationStep(
                    direction: .turnRight,
                    instruction: "Turn Right",
                    subInstruction: "toward the elevators and stairs",
                    distance: 50,
                    image: "ADA_Step 2"
                ),
                NavigationStep(
                    direction: .goDown,
                    instruction: "Go Down",
                    subInstruction: "to the lower level",
                    distance: 50,
                    image: "ADA_Step 3"
                ),
                NavigationStep(
                    direction: .turnRight,
                    instruction: "Turn Right",
                    subInstruction: "after reaching the bottom of the stairs",
                    distance: 50,
                    image: "ADA_Step 4"
                ),
                NavigationStep(
                    direction: .goStraight,
                    instruction: "Go Straight",
                    subInstruction: "until you reach \(destination.name)",
                    distance: 50,
                    image: "ADA_Step 5"
                )
            ]
        )
    }
    
    // Organize paths by destination ID for efficient lookup
    static let paths: [String: [NavigationPath]] = [
        // Paths to Green Eatery
        Place.greenEatery.id: [
            // From Apple Developer Academy to Green Eatery
            NavigationPath(
                startingPoint: .appleAcademy,
                destination: Place.greenEatery,
                steps: [
                    NavigationStep(
                        direction: .turnLeft,
                        instruction: "Turn Left",
                        subInstruction: "from the Apple Developer Academy entrance",
                        distance: 50,
                        image: "ADA_Step 1"
                    ),
                    NavigationStep(
                        direction: .turnRight,
                        instruction: "Turn Right",
                        subInstruction: "toward the elevators and stairs",
                        distance: 50,
                        image: "ADA_Step 2"
                    ),
                    NavigationStep(
                        direction: .goDown,
                        instruction: "Go Down",
                        subInstruction: "to the lower level",
                        distance: 50,
                        image: "ADA_Step 3"
                    ),
                    NavigationStep(
                        direction: .turnRight,
                        instruction: "Turn Right",
                        subInstruction: "after reaching the bottom of the stairs",
                        distance: 50,
                        image: "ADA_Step 4"
                    ),
                    NavigationStep(
                        direction: .goStraight,
                        instruction: "Go Straight",
                        subInstruction: "until you reach Green Eatery",
                        distance: 50,
                        image: "ADA_Step 5"
                    )
                ]
            ),
            // From Halte The Breeze to Green Eatery
            NavigationPath(
                startingPoint: .halteBreeze,
                destination: Place.greenEatery,
                steps: [
                    NavigationStep(
                        direction: .goStraight,
                        instruction: "Go Straight",
                        subInstruction: "through the main entrance",
                        distance: 30,
                        image: "ADA_Step 1"
                    ),
                    NavigationStep(
                        direction: .turnLeft,
                        instruction: "Turn Left",
                        subInstruction: "at the lobby",
                        distance: 20,
                        image: "ADA_Step 2"
                    ),
                    NavigationStep(
                        direction: .goDown,
                        instruction: "Go Down",
                        subInstruction: "to basement level",
                        distance: 40,
                        image: "ADA_Step 3"
                    )
                ]
            )
        ],
        
        // Paths to Starbucks
        Place.starbucks.id: [
            // From Apple Developer Academy to Starbucks
            NavigationPath(
                startingPoint: .appleAcademy,
                destination: Place.starbucks,
                steps: [
                    NavigationStep(
                        direction: .turnRight,
                        instruction: "Turn Right",
                        subInstruction: "from the Apple Developer Academy entrance",
                        distance: 30,
                        image: "ADA_Step 1"
                    ),
                    NavigationStep(
                        direction: .goStraight,
                        instruction: "Go Straight",
                        subInstruction: "along the corridor",
                        distance: 50,
                        image: "ADA_Step 2"
                    ),
                    NavigationStep(
                        direction: .turnLeft,
                        instruction: "Turn Left",
                        subInstruction: "at the end of corridor",
                        distance: 20,
                        image: "ADA_Step 3"
                    )
                ]
            )
        ]
    ]
}

