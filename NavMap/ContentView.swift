//
//  ContentView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 06/05/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isShowingLookAround = false
    @State private var isShowingBottomSheet = true
    @State private var searchText = ""
    @State private var selectedPlace: Place? = nil
    @State private var sheetDetent: PresentationDetent = .fraction(0.44)
    @State private var isSearching = false

    let samplePlaces: [Place] = [
        Place(
            id: "green_eatery",
            name: "Green Eatery Canteen",
            address: "Lt. B Gedung GOP 9",
            imageName: "Green Eatery",
            tags: ["Food", "Drink", "GOP 9"],
            hours: "Always available",
            description: "The GOP 9 Canteen, better known as Green Eatery, is located in the basement of Green Office Park 9 in BSD City, offering a comfy and affordable dining spot for employees and visitors. It serves up a variety of tasty dishes, from Indonesian favorites like nasi campur and soto to light snacks and refreshing drinks, all in a clean and practical setting. The go-to eatery for GOP 9 folks is Dapur Kasturi, which also offers convenient pick-up service through WhatsApp.",
            latitude: -6.302072012617987,
            longitude: 106.65252618491591
        ),
        Place(
            id: "alfamart_express",
            name: "Alfamart Express",
            address: "Lt. B1 Gedung GOP 9",
            imageName: "Alfamart Express",
            tags: ["Market", "GOP 9"],
            hours: "Always available",
            description: "Alfamart Express is an Indonesian convenience store franchise chain under the Alfamart network. It stocks typical Indonesian convenience store items like snacks, soft drinks, fried chicken, bread, and other daily essentials. Recommended picks at Alfamart Express include Bean Spot coffee, ready-to-eat meals, and handy local snacks. They also roll out cool promos like special discounts or budget-friendly combo deals, making shopping there even more wallet-friendly",
            latitude: -6.302356460314039,
            longitude: 106.65265806756328
        ),
        Place(
            id: "toilet_basement_gop9",
            name: "Toilet Basement GOP 9",
            address: "Lt. B1 Gedung GOP 9",
            imageName: "default",
            tags: ["Toilet", "GOP 9"],
            hours: "Always available",
            description: "Place for sanitation-related activities, the toilet here is, of course, clean and fresh-smelling. Shower room available.",
            latitude:-6.302183,
            longitude: 106.652667
        ),
        Place(
            id: "mushola_gop9",
            name: "Mushola GOP 9",
            address: "Lt. B1 Gedung GOP 9",
            imageName: "Mushola GOP 9",
            tags: ["Mushola", "GOP 9"],
            hours: "Always available",
            description: "A place of worship for Muslim men and women, featuring two mushola locations, both conveniently close to Green Eatery.",
            latitude:-6.302097,
            longitude: 106.652535
        ),
        Place(
            id: "chatime",
            name: "Chatime",
            address: "The Breeze, Batik 1 L.10A",
            imageName: "Chatime",
            tags: ["Drink", "The Breeze"],
            hours: "10.00 - 22.00 WIB",
            description: "Chatime is a brewed tea beverage provider from Taiwan offering more than 50 flavor variants. In Indonesia, Chatime has been part of the Kawan Lama Group since 2011.",
            latitude: -6.3017966669085315,
            longitude: 106.65423951905721
        ),
        Place(
            id: "lawson",
            name: "Lawson",
            address: "Lt. B1 Gedung GOP 6",
            imageName: "Lawson",
            tags: ["Food", "Drink", "GOP 6"],
            hours: "08.00 - 20.30 WIB",
            description: "Lawson, Inc. is a Japanese convenience store franchise chain. Lawson offers a wide variety of snacks and drinks to choose from. It's well-known for its oden, choux, tteokbokki, and onigiri. A while back, their snack tray combo—a mix of drinks and light bites—went pretty viral too. Lawson also has some cool deals to help you shop smarter; check out their official social media for more details.",
            latitude: -6.302819,
            longitude: 106.652985
        ),
        Place(
            id: "cinema_xxi",
            name: "Cinema XXI",
            address: "The Breeze, Pavillion L. 80",
            imageName: "Cinema XX1",
            tags: ["Entertainment", "The Breeze"],
            hours: "11:30 - 22:00 WIB",
            description: "Cinema The Breeze XXI is one of the cinemas under the Cinema XXI network. Committed to providing the best quality entertainment at affordable prices, Cinema XXI is ready to become a second home for enjoying quality movies and snacks.",
            latitude: -6.302403435211009,
            longitude: 106.65412363124017
        ),
        Place(
            id: "ranch_market",
            name: "Ranch Market",
            address: "The Breeze, Pavilion 5 L.79",
            imageName: "Ranch Market",
            tags: ["Market", "The Breeze"],
            hours: "08:00 - 22:00 WIB",
            description: "Ranch Market is a supermarket offering high-quality and unique products, focusing on healthy lifestyle products like organic and gluten-free items, catering to high-end and middle-high customers.",
            latitude: -6.302220308866543,
            longitude: 106.65324952179628
        ),
        Place(
            id: "guardian",
            name: "Guardian",
            address: "The Breeze L. 56M",
            imageName: "Guardian",
            tags: ["Pharmacy", "The Breeze"],
            hours: "10:00 - 22:00 WIB",
            description: "Guardian is a leading modern retail brand in Southeast Asia in health and beauty, offering a wide range of quality products and the best services for its customers.",
            latitude: -6.302362,
            longitude: 106.654716
        ),
        Place(
            id: "starbucks",
            name: "Starbucks",
            address: "The Breeze",
            imageName: "Starbucks",
            tags: ["Coffee", "The Breeze"],
            hours: "09.00 - 22.00 WIB",
            description: "Kedai kopi ternama yang cocok untuk nongkrong atau mengerjakan tugas.",
            latitude: -6.301663,
            longitude: 106.654311
        ),
        Place(
            id: "apple_developer_academy",
            name: "Apple Developer Academy @BINUS",
            address: "GOP 9",
            imageName: "Apple",
            tags: ["Work", "GOP 9"],
            hours: "08.00 - 18.00 WIB",
            description: "The Apple Developer Academy @BINUS is Asia's first ever initiative to empower Indonesia's economy by creating world-class developers for the world's most innovative and vibrant app ecosystem.",
            latitude: -6.301966,
            longitude: 106.652562
        ),
        Place(
            id: "toilet_gop6",
            name: "Toilet GOP 6",
            address: "Lt. B1 Gedung GOP 6",
            imageName: "default",
            tags: ["Toilet", "GOP 6"],
            hours: "nil",
            description: "Place for sanitation-related activities, the toilet here is, of course, clean and fresh-smelling.",
            latitude: -6.3031543609560545,
            longitude: 106.65282103967742
        ),
        Place(
            id: "mushola_gop6",
            name: "Mushola GOP 6",
            address: "Lt. B1 Gedung GOP 6",
            imageName: "default",
            tags: ["Mushola", "GOP 6"],
            hours: "nil",
            description: "A place for praying activities for Muslim men and women.",
            latitude: -6.303158359948217,
            longitude: 106.65281701636374
        ),
        Place(
            id: "bank_mandiri",
            name: "Bank Mandiri KCP Tangerang",
            address: "The Breeze, Unit Lake 19",
            imageName: "Bank Mandiri",
            tags: ["Atm", "The Breeze"],
            hours: "08.00 - 15.00 WIB",
            description: "Bank Mandiri ATMs are available to perform transactions such as transfers, cash withdrawals and deposits",
            latitude: -6.3032065003632,
            longitude: 106.65304011043865
        ),
        Place(
            id: "familymart",
            name: "FamilyMart",
            address: "Lt. B1 Gedung Traveloka Campus",
            imageName: "FamilyMart",
            tags: ["Food", "Drink", "GOP 1"],
            hours: "06.00 - 20.00 WIB",
            description: "FamilyMart Company, Ltd. is a Japanese convenience store franchise chain. FamilyMart stores provide typical Japanese convenience store items, such as snacks and drinks, fried chicken, onigiri/omusubi (rice balls) and many more. Recommended menus for FamilyMart are Kopi Susu Keluarga (KSK), oden and tteokbokki. FamilyMart also often offers attractive promotions such as special discounts at certain hours so you can shop more economically.",
            latitude: -6.301664612360021,
            longitude: 106.65041439393563
        ),
        Place(
            id: "spincity",
            name: "Spincity",
            address: "The Breeze BSD City",
            imageName: "Spincity",
            tags: ["Entertainment", "The Breeze"],
            hours: "10:00 - 22:00 WIB",
            description: "Spincity Bowling Alley is a bowling entertainment center where you can have fun playing bowling and enjoy casual dining with friends and family.",
            latitude: -6.302567081783078,
            longitude: 106.65541549572431
        ),
        Place(
            id: "subway",
            name: "Subway",
            address: "The Breeze BSD City Lake Level L57A",
            imageName: "Subway",
            tags: ["Food", "The Breeze"],
            hours: "09:00 - 22:00 WIB",
            description: "A casual counter-serve chain for build-your-own sandwiches and salads, with plenty of healthy options.",
            latitude: -6.302347984117658,
            longitude: 106.65469040187723
        ),
        Place(
            id: "kenangan_signature",
            name: "Kenangan Signature",
            address: "The Breeze, Unit L.26",
            imageName: "Kenangan Signature",
            tags: ["Coffee", "The Breeze"],
            hours: "08:00 - 22:00 WIB",
            description: "Kenangan Signature is the premium version of Kopi Kenangan, offering a more luxurious coffee experience with an exclusive look and packaging.",
            latitude: -6.3014927997370895,
            longitude: 106.65414421536877
        )
    ]
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return samplePlaces
        } else {
            let searchTermLower = searchText.lowercased()
            return samplePlaces.filter { place in
                // Check if any tag contains the search text (case-insensitive)
                let matchesTag = place.tags.contains { tag in
                    tag.lowercased().contains(searchTermLower)
                }
                // Check if name contains the search text
                let matchesName = place.name.lowercased().contains(searchTermLower)
                
                return matchesName || matchesTag
            }
        }
    }

    var body: some View {
        ZStack {
            MapContainerView(
                cameraPosition: $mapViewModel.cameraPosition,
                mapSelection: $mapViewModel.mapSelection,
                places: samplePlaces,
                route: mapViewModel.route,
                onPlaceSelected: { place in
                    withAnimation {
                        mapViewModel.selectPlace(place)
                        mapViewModel.addToRecents(place)
                        selectedPlace = place
                        isShowingBottomSheet = true
                        sheetDetent = .fraction(0.44)
                    }
                }
            )
            .sheet(isPresented: $isShowingBottomSheet) {
                PlaceListView(
                    places: filteredPlaces,
                    searchText: $searchText,
                    selectedPlace: $selectedPlace,
                    isSheetPresented: $isShowingBottomSheet,
                    onPlaceSelected: { place in
                        mapViewModel.selectPlace(place)
                        mapViewModel.addToRecents(place)
                        selectedPlace = place
                        sheetDetent = .fraction(0.44)
                    },
                    onGetDirections: { place in
                        let destination = CLLocationCoordinate2D(
                            latitude: place.latitude,
                            longitude: place.longitude
                        )
                        mapViewModel.getDirections(to: destination)
                        sheetDetent = .fraction(0.44)
                    },
                    onClearRoute: {
                        mapViewModel.clearRoute()
                    }
                )
                .presentationDetents([.fraction(0.44), .fraction(0.99)], selection: $sheetDetent)
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled(true)
                .onDisappear {
                    mapViewModel.mapSelection = nil
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .lookAroundViewer(isPresented: $isShowingLookAround, initialScene: lookAroundScene)
            
            .overlay(alignment: .topLeading) {
                SearchBarView(searchText: $searchText, onSubmit: {
                    // When user hits enter/search, show PlaceList with filtered results
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = false  // Close LocationSearchView
                        isShowingBottomSheet = true  // Show PlaceList
                    }
                })
                .overlay {
                    Button(action: {
                        withAnimation {
                            isSearching = true  // Show LocationSearchView
                            isShowingBottomSheet = false  // Hide PlaceList
                        }
                    }) {
                        Rectangle()
                            .fill(.clear)
                    }
                }
                .padding(.top, 8)
            }
            
            if isSearching {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                LocationSearchView(
                    searchText: $searchText,
                    isSearching: $isSearching,
                    isShowingBottomSheet: $isShowingBottomSheet,
                    mapViewModel: mapViewModel,
                    places: samplePlaces,
                    onPlaceSelected: { place in
                        mapViewModel.selectPlace(place)
                        mapViewModel.addToRecents(place)
                        selectedPlace = place
                        isSearching = false  // Close LocationSearchView
                        isShowingBottomSheet = true  // Show PlaceList
                    },
                    onCategorySelected: { category in
                        searchText = category
                        isSearching = false  // Close LocationSearchView
                        isShowingBottomSheet = true  // Show PlaceList
                    }
                )
            }
        }
    }
    
    func getLookAroundScene(from coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        do {
            return try await MKLookAroundSceneRequest(coordinate: coordinate).scene
        } catch {
            print("cannot retrieve Look Around scene: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D {
    static let starbucks = CLLocationCoordinate2D (latitude:-6.301663, longitude: 106.654311)
    static let apple = CLLocationCoordinate2D (latitude:-6.301966, longitude: 106.652562)
    static let arabica = CLLocationCoordinate2D (latitude:-6.301608, longitude: 106.653157)
}
