//
//  ContentView.swift
//  VisionApp
//
//  Created by Danil Denha on 2/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var gifUrl: URL?
    
    var body: some View {
        VStack {
            if let gifUrl = gifUrl {
                AsyncImage(url: gifUrl)
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                    .padding
            }
            Button("Create a random gift") {
                fetchRandomGif()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 23.0))
        }
    }
    func fetchRandomGif(){
        let apiKey = "JsEwg2CIMWU2uckv91l1duMPNR7S4WqB";
        let url = URL(string:
                "https://api.giphy.com/v1/gifs/random?api_key=\(apiKey)")!
        
        let task = URLSession.shared.dataTask(with: url) { data,
            response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(RandomGiphyResponse.self,
                                         from: data) {
                    DispatchQueue.main.async {
                        self.gifUrl = URL(string:
                                            response.data.images.fixed_height.url)
                    }
                }
            }
        }
        task.resume()
        
    }
}

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



#Preview(windowStyle: .automatic) {
    ContentView()
}
