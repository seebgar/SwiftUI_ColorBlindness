//
//  ContentView.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home(image: UIImage(systemName: "photo.on.rectangle") ?? UIImage() )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
