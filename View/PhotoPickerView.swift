//
//  PhotoPickerView.swift
//  ChronosApp
//
//  Created by Петя on 16.10.2026.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPickerView: View {
    
    @State private var selectedItem: [PhotosPickerItem] = []
    @Binding var loadedImage: [Data]
    
    var body: some View {
        
        
        VStack{
            PhotosPicker("Добавить фото", selection: $selectedItem)
            
            ForEach(loadedImage, id:\.self){newImage in
                if let uiImage = UIImage(data: newImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 150)
                        .scaledToFit()
                }
                
            }
            
        }
        .onChange(of: selectedItem){
            Task{
                for item in selectedItem{
                    if let data = try? await item.loadTransferable(type: Data.self){
                        loadedImage.append(data)
                    }
                }
                selectedItem = []
            }
        }
        
        
        
    }
    
}

#Preview {
    PhotoPickerView(loadedImage: .constant([]))
}
