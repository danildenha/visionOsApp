import SwiftUI
import RealityKit
import RealityKitContent
import WebKit // Import WebKit framework

//first window that greets the user
struct WelcomeView: View {

    @State private var showApp = false

    var body: some View {
        ZStack { // Create a layered background for visual depth
            Image("welcome_background") // Replace with your desired background image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all) // Stretch background to all edges

            VStack {
                Spacer() // Add space at the top

                Image("app_logo") // Display a visually appealing app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed

                Text("Welcome to the Gif App!")
                    .font(.largeTitle)
                    .foregroundColor(.white) // Ensure contrast with background
                    .shadow(color: .gray, radius: 5) // Add subtle shadow for depth

                Text("Create and share stunning animated GIFs!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7)) // Dimmer text for hierarchy

                Spacer() // Add space at the bottom

                Button("Start Creating!") { // Emphasize action and creativity
                    showApp = true
                }
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)) // Vibrant gradient background
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .font((.system(size: 20, weight: .bold)))
                .padding(.horizontal) // Add some padding for better touch area
                Spacer() // Add space below button
            } // End VStack
            .padding(.horizontal, 30) // Pad the content for better margins
        } // End ZStack
        .fullScreenCover(isPresented: $showApp) {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var gifUrl: URL?
    
    var body: some View {
        VStack {
            if let gifUrl = gifUrl {
                // Use WebView to display the GIF
                WebView(url: gifUrl)
                    .frame(width: 500, height: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding()
            } else { // Show placeholder when no GIF
                Text("No GIF yet. Create one!")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            Button("Create a random gif") {
                fetchRandomGif()
            }
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)) // Vibrant gradient background
                  .foregroundColor(.white)
                  .clipShape(RoundedRectangle(cornerRadius: 25.0))
                  .font(.system(size: 20, weight: .bold))
                  .padding(.horizontal) // Add some padding for better touch area
                  .padding(.bottom, 20) // Add some padding for better touch area
        }
    }
    
    func fetchRandomGif() {
        let apiKey = "JsEwg2CIMWU2uckv91l1duMPNR7S4WqB"
        let url = URL(string: "https://api.giphy.com/v1/gifs/random?api_key=\(apiKey)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(RandomGiphyResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.gifUrl = URL(string: response.data.images.fixed_height.url)
                    }
                }
            }
        }
        task.resume()
    }
}

// Define the structs here to ensure they're in scope
struct RandomGiphyResponse: Codable {
    let data: Gif
}
struct Gif: Codable {
    let images: GifImages
}
struct GifImages: Codable {
    let fixed_height: GifUrl
}
struct GifUrl: Codable {
    let url: String
}

// WebView struct to display the GIF
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview(windowStyle: .automatic) {
  WelcomeView()
}
