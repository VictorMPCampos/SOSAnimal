import SwiftUI

struct AddAnimal: View {
    @Binding var showModal: Bool
    var addAnimalAction: (String, String) -> Void

    @State private var tempAnimalName = ""
    @State private var selectedStatus = "Selecione o Status"
    let statusOptions = ["Situação de Rua", "Situação de Maus Tratos", "Perdido"]

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                TextField("", text: $tempAnimalName)
                    .foregroundColor(.white)
                    .padding(15)
                    .background(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .frame(width: 308, height: 45)
                
                if tempAnimalName.isEmpty {
                    Text("Qual o animal?")
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                }
            }
            .padding(.horizontal, 22)
            
            Menu {
                Picker("Selecione o Status", selection: $selectedStatus) {
                    ForEach(statusOptions, id: \.self) { status in
                        Text(status).tag(status)
                    }
                }
            } label: {
                HStack {
                    Text(selectedStatus)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                }
                .padding()
                .frame(width: 310, height: 50)
                .background(Color(red: 0.46, green: 0.46, blue: 0.46))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .frame(width: 308, height: 50)

            Button(action: {
                addAnimalAction(tempAnimalName, selectedStatus)
                showModal = false
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 126, height: 40)
                    .background(LinearGradient(
                        stops: [Gradient.Stop(color: .black, location: 0.00)],
                        startPoint: UnitPoint(x: 0.7, y: 0),
                        endPoint: UnitPoint(x: 0.3, y: 1)))
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

