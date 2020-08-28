//
//  CollectionView.swift
//  Rijk-SwiftUI
//
//  Created by Alessio Roberto on 17/08/2020.
//

import SwiftUI

struct CollectionView: View {
    @ObservedObject private var viewModel = CollectionViewModel()

    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack {
                    Text("Rembrandt van Rijn")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                    Button(action: self.getCollection, label: {
                        Image(systemName: "arrow.down.square.fill")
                            .foregroundColor(.white)
                            .font(.title)
                    })
                    .padding()
                }
                List(viewModel.collection ) { obcj in
                    CollectionCell(collection: obcj)
                }
            }
        }
    }
}

// MARK: - Event Handlers
extension CollectionView {
  func getCollection() {
    viewModel.data()
  }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

struct CollectionCell: View {
    var collection: Collection

    var body: some View {
        HStack {
            Text("\(collection.title)")
            Spacer()
            ImageView(withURL: collection.webImage.url)
        }
    }
}
