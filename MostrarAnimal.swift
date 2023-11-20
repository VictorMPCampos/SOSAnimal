import SwiftUI

struct MostrarAnimal: View {
    @Binding var showModal: Bool
    
    let animalMarker: AnimalMarker
    
    var removeAnimalAction1: (AnimalMarker) -> Void
    
    var removeAnimalAction2: (AnimalMarker) -> Void

    var body: some View {
        VStack(spacing: 20) {

            TextField("Nome", text: .constant(animalMarker.nome))
                .foregroundColor(.white)
                .disabled(true)
                .padding()
                .background(Color(red: 0.46, green: 0.46, blue: 0.46))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .frame(width: 308, height: 45)

            TextField("Status", text: .constant(animalMarker.status))
                .foregroundColor(.white)
                .disabled(true)
                .padding()
                .background(Color(red: 0.46, green: 0.46, blue: 0.46))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .frame(width: 308, height: 45)

            VStack(spacing: 20) {
                Button(action: {
                    removeAnimalAction2(animalMarker)
                    showModal = false
                }) {
                    Text("Não está mais aí")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 40)
                        .background(Color(red: 0.46, green: 0.46, blue: 0.46))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }

                Button(action: {
                    removeAnimalAction1(animalMarker)
                    showModal = false
                }) {
                    Text("Animal Resgatado")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 40)
                        .background(.green)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }
            }
            .padding()
        }
    }
}



#Preview {
    ContentView()
}
