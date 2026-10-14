//
//  PhotoStorage.swift
//  ChronosApp
//
//  Created by Петя on 14.10.2026.
//

import Foundation


struct PhotoStorage{
    
    func savePhoto(data: Data) throws -> UUID{
        let id = UUID()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let firstURL = urls.first else {throw CocoaError(.fileNoSuchFile)}
        let fileName = "\(id.uuidString).png"
        let fileURL = firstURL.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        
        
        
        return id
    }
    
    func loadPhoto(id: UUID) throws -> Data{
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let firstURL = urls.first else{
            throw CocoaError(.fileNoSuchFile)
        }
        let fileURL = firstURL.appendingPathComponent("\(id).png")
        let data = try Data(contentsOf: fileURL)
        
        return data
    }
    
    
    func deletePhoto(id: UUID) throws{
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let firstURL = urls.first else{
            throw CocoaError(.fileNoSuchFile)
        }
        let deleteURL = firstURL.appendingPathComponent("\(id).png")
        if FileManager.default.fileExists(atPath: deleteURL.path) {
                try FileManager.default.removeItem(at: deleteURL)
            } else {
                throw CocoaError(.fileNoSuchFile)
            }
        
        
    }
    
}
