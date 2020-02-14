//
//  ImageEditView.swift
//  Color Blind
//
//  Created by Sebastian on 2/13/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct ImageEditView: View {
    
    @Binding var selectedImage: UIImage
    @Binding var showFilter: Bool
    @State var startLoading: Bool = false
    @State private var showModes: Bool = false
    @State private var mode: String?
    
    func setColor( type: ColorBlindType ) -> Void {
        self.showModes = false
        self.mode = globalDicNames[type.rawValue]
        
        DispatchQueue.main.async {
            self.startLoading = true
            if let im = dicImages["\(type.rawValue)"] {
                self.selectedImage = im
            } else {
                dicImages["\(type.rawValue)"] = CBPixelHelper.processPixelsInImage( globalOriginal , type: type)
                self.selectedImage = dicImages["\(type.rawValue)"] ?? self.selectedImage
            }
            self.startLoading = false
        }
        
    }
    
    func setOriginal() -> Void {
        self.selectedImage = globalOriginal
    }
    
    var body: some View {
        ZStack {
            
            Color.black.frame(maxWidth: .infinity).frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Header(showFilter: self.$showFilter, selectedImage: self.$selectedImage)
                
                if self.startLoading {
                    Image(systemName: "arrow.2.circlepath")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .padding(.vertical, 100)
                        .rotationEffect(.degrees(360))
                        .animation(Animation.default.repeatForever())
                        .foregroundColor(.white)
                    
                } else {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: bounds.height * 0.72)
                        .padding(.bottom, 16)
                }
                
                //                Actions(showModes: self.$showModes, setColor: self.setColor(type:), setOriginal: self.setOriginal)
                
                Button(action: {
                    self.showModes = true
                }) {
                    VStack (alignment: .center){
                        Text("Change Filter").bold().foregroundColor(.white)
                    }
                }
                
                
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            
            iPadPopOver(showModes: self.$showModes, setColor: self.setColor(type:), setOriginal: self.setOriginal)
                .offset(y: self.showModes ? 0 : bounds.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
            
        }
        
        
    }
}

struct ImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditView(selectedImage: .constant(UIImage(named: "bird") ?? UIImage()), showFilter: .constant(true))
    }
}



struct Header: View {
    @Binding var showFilter: Bool
    @Binding var selectedImage: UIImage
    @State var mode: String?
    @State var showAlert: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                self.showFilter = false
            } ) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
            }
            Spacer()
            Text(mode ?? "")
                .foregroundColor(.white)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                UIImageWriteToSavedPhotosAlbum(self.selectedImage, nil, nil, nil)
                self.showAlert.toggle()
            } ) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text("Image saved"))
            }
        }
        .frame(height: bounds.height * 0.10)
        .offset(x: 0, y: 0)
    }
}



struct iPadPopOver: View {
    @Binding var showModes: Bool
    var setColor: (_ type: ColorBlindType) -> Void
    var setOriginal : () -> Void
    var modWidth: CGFloat = 300
    
    var body: some View {
        VStack (spacing: 12) {
            Button(action: {
                self.showModes = false
                self.setColor(.achromatomaly)
            }) {
                VStack {
                    Text("Achromatomaly").frame(width: modWidth)
                    Divider()
                }
            }.padding(.top, 12)
            Button(action: {
                self.showModes = false
                self.setColor(.achromatopsia)
            }) {
                VStack {
                    Text("Achromatopsia").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.deuteranomaly)
            }) {
                VStack {
                    Text("Deuteranomaly").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.deuteranopia)
            }) {
                VStack {
                    Text("Deuteranopia").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.protanomaly)
            }) {
                VStack {
                    Text("Protanomaly").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.protanopia)
            }) {
                VStack {
                    Text("Protanopia").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.tritanomaly)
            }) {
                VStack {
                    Text("Tritanomaly").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setColor(.tritanopia)
            }) {
                VStack {
                    Text("Tritanopia").frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
                self.setOriginal()
            }) {
                VStack {
                    Text("Original").foregroundColor(.gray).frame(width: modWidth)
                    Divider()
                }
            }
            Button(action: {
                self.showModes = false
            }) {
                VStack {
                    Text("Cancel").foregroundColor(.red).frame(width: modWidth)
                }
            }.padding(.bottom, 12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(width: modWidth)
        .padding()
    }
}
