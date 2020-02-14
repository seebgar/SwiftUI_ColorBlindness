//
//  Home.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @State var image: UIImage = UIImage()
    @State private var showPicker: Bool = false
    @State private var showCamera: Bool = false
    @State private var showFilter: Bool = false    
    
    var body: some View {
        ZStack {
            
            Color.RGB(red: 233, green: 237, blue: 240)
            
            VStack (alignment: .center) {
                
                HStack {
                    Button(action: {
                        self.showPicker.toggle();
                        self.showCamera = false
                    } ) {
                        VStack {
                            Text("Camera Roll")
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 160, height: 80)
                        }
                        .background(Color.RGB(red: 233, green: 237, blue: 240))
                        .frame(width: 160, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(1), radius: 12, x: -8, y: -10)
                    }
                    .padding()
                    
                    Button(action: {
                        self.showPicker.toggle();
                        self.showCamera = true
                    } ) {
                        VStack {
                            Text("Camera")
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 160, height: 80)
                        }
                        .background(Color.RGB(red: 233, green: 237, blue: 240))
                        .frame(width: 160, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(1), radius: 12, x: -8, y: -10)
                    }
                    .padding()
                }
                .frame(height: 20)
                .padding(.top, 32)
                
                
            }
            .padding(.top)
            .sheet(isPresented: $showPicker) {
                ImagePickerView(isPresenting: self.$showPicker, image: self.$image, showCamera: self.$showCamera, showFilter: self.$showFilter)
            }
            
            ImageEditView(selectedImage: self.$image, showFilter: self.$showFilter)
                .offset(y: showFilter ? 0.0 : bounds.height)
                .animation(.default)
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}





