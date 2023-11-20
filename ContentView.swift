import SwiftUI
import CoreLocation
import MapKit

class UserProfile: ObservableObject {
    var name: String
    @Published var points: Int
    var title: String
    @Published var animalsMarked: Int
    
    init(name: String, points: Int, title: String, animalsMarked: Int) {
        self.name = name
        self.points = points
        self.title = title
        self.animalsMarked = animalsMarked
    }
    
    func checkTitle(){
        if points < 50 {
            title = "Novato"
        }
        else if points < 100 {
            title = "Ajudante dos Animais"
        }
        else if points < 500 {
            title = "Super Ajudante dos Animais"
        }
        else if points < 2000 {
            title = "Super Homem Animal"
        }
        else if points > 2000 {
            title = "Noé Moderno"
        }
    }
    
    func addPoints(for newAnimal: AnimalMarker) {
        points += 10
        animalsMarked += 1
        checkTitle()
    }
    
    func removePoints1(for removedAnimal: AnimalMarker) {
        points += 10
        checkTitle()
    }
    
    func removePoints2(for removedAnimal: AnimalMarker) {
        points += 5
        checkTitle()
    }
    
}


struct AnimalMarker: Identifiable {
    let id = UUID()
    var nome: String
    var status: String
    var coordenadas: CLLocationCoordinate2D
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    @State var animalMarkers: [AnimalMarker] = []
    
    @State private var showingModal = false
    
    @State private var showingInfoModal = false
    
    @State private var selectedAnimalMarker: AnimalMarker?
    
    @State private var isShowingProfile = false
    
    @State private var showStarAnimation = false
    
    @StateObject var userProfile = UserProfile(name: "Usuário", points: 0, title: "Novato", animalsMarked: 0)
    
    let animalTeste = AnimalMarker(nome: "Cachorro", status: "Situação de Rua", coordenadas:  CLLocationCoordinate2D(latitude: -23.548286, longitude: -46.652963))
    
    func addAnimalMarker(at coordinate: CLLocationCoordinate2D, name: String, status: String) {
        let newMarker = AnimalMarker(nome: name, status: status, coordenadas: coordinate)
        animalMarkers.append(newMarker)
        userProfile.addPoints(for: newMarker)
        
        withAnimation {
            showStarAnimation = true
            }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showStarAnimation = false
            }
        }
    }
    
    func removeAnimalMarker1(_ marker: AnimalMarker) {
        animalMarkers.removeAll { $0.id == marker.id }
        userProfile.removePoints1(for: marker)
        
        withAnimation {
            showStarAnimation = true
            }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showStarAnimation = false
            }
        }
    }
    
    func removeAnimalMarker2(_ marker: AnimalMarker) {
        animalMarkers.removeAll { $0.id == marker.id }
        userProfile.removePoints2(for: marker)
        
        withAnimation {
            showStarAnimation = true
            }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showStarAnimation = false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack () {
                Map(position: $viewModel.camera){
                    ForEach(animalMarkers) { animalMarker in
                        Annotation(animalMarker.nome, coordinate: animalMarker.coordenadas){
                            ZStack{
                                Circle().frame(width: 30, height: 30).foregroundColor(.blue)
                                Image(systemName: "dog").resizable(resizingMode: .stretch).frame(width: 15, height: 15)
                                    .onTapGesture {
                                        self.selectedAnimalMarker = animalMarker
                                        self.showingInfoModal = true
                                    }
                            }
                        }
                    }
                    UserAnnotation()
                }
                .onAppear{
                    animalMarkers.append(animalTeste)
                }
                .mapControls{
                    MapUserLocationButton()
                    MapCompass()
                    MapPitchToggle()
                }
                Button(action: {
                    isShowingProfile = true
                }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding()
                        .tint(.black)
                }
                .background(Circle().fill(Color.gray))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .position(x: 40, y: 10)
                .shadow(radius: 3)
                if showStarAnimation {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.yellow)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                        .position(x: 220, y: 100)
                }
                VStack {
                    Spacer()
                    Button(action: {
                        self.showingModal = true
                    }) {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 70, height: 40)
                                .background(
                                    LinearGradient(
                                        stops: [Gradient.Stop(color: .black, location: 0.00)],
                                        startPoint: UnitPoint(x: 0.7, y: 0),
                                        endPoint: UnitPoint(x: 0.3, y: 1)
                                    )
                                )
                                .cornerRadius(20)
                                .frame(width: 70, height: 40)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            Text("+")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                }
                if showingModal {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showingModal = false
                        }
                    AddAnimal(showModal: $showingModal) { name, status in
                        addAnimalMarker(at: viewModel.currLocation, name: name, status: status)
                    }
                    .frame(width: 375, height: 350)
                    .background(Color(red: 0.24, green: 0.24, blue: 0.24))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .padding(20)
                    .transition(.scale)
                    .foregroundColor(.clear)
                }
                if showingInfoModal, let selectedMarker = selectedAnimalMarker {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showingInfoModal = false
                        }
                MostrarAnimal(showModal: $showingInfoModal, animalMarker: selectedMarker, removeAnimalAction1: removeAnimalMarker1, removeAnimalAction2: removeAnimalMarker2)
                    .frame(width: 375, height: 350)
                    .background(Color(red: 0.24, green: 0.24, blue: 0.24))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .padding(20)
                    .transition(.scale)
                    .foregroundColor(.clear)
                }
            }
            .navigationDestination(isPresented: $isShowingProfile){
                ProfileView(userProfile: userProfile)
            }
        }
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var camera: MapCameraPosition = .userLocation(followsHeading: true, fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -23.548286, longitude: -46.652963), latitudinalMeters: 300, longitudinalMeters: 300)))
    
    @Published var currLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -23.549, longitude: -46.653)
    
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.startUpdatingLocation()
        } else {
            print("Localização desligada, ligar nas opções.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                self.currLocation = location.coordinate
            }
        }
    
    private func checkLA() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Sua localização está restringida.")
        case .denied:
            print("Você bloqueou o app de ter sua localização.")
        case .authorizedAlways, .authorizedWhenInUse:
            camera = .userLocation(followsHeading: true, fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -23.548286, longitude: -46.652963), latitudinalMeters: 300, longitudinalMeters: 300)))
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLA()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
        }
    }
}


#Preview {
    ContentView()
}
