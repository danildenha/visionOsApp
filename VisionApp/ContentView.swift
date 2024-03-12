import SwiftUI
import RealityKit
import RealityKitContent
import WebKit // Import WebKit framework

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
            }
            Button("Create a random gif") {
                fetchRandomGif()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 23.0))
            .font((.system(size: 20, weight: .bold)))
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

// Preview struct
#Preview(windowStyle: .automatic) {
    ContentView()
}
