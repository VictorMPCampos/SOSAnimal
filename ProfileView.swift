import SwiftUI

struct ProfileView: View {
    var userProfile: UserProfile

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 150)

            Text(userProfile.name)
                .font(.title)
                .padding(.top, 16)

            Text(userProfile.title)
                .font(.headline)
                .padding(.top, 8)

            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                Text("\(userProfile.points)")
                    .font(.title)
            }
            .padding(.top, 8)

            Text("ANIMAIS MARCADOS: \(userProfile.animalsMarked)")
                .font(.headline)
                .padding(.top, 16)

            Spacer()
        }
        .navigationBarTitle(Text("Perfil"), displayMode: .inline)
        .padding()
    }
}


#Preview {
    ContentView()
}
