//
//  ImageView.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 22/08/2020.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage(systemName: "hourglass")!

    private let placehodeler = UIImage(systemName: "hourglass")!

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            if image == placehodeler {
                Image(uiImage: image)
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            }
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? placehodeler
        }
    }
}
