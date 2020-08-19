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
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .padding()
                    Button(action: self.getCollection, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    })
                    .padding()
                }
                List(viewModel.collection ) { obcj in
                        HStack {
                            Text("\(obcj.title)")
                        }
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
