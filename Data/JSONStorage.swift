//
//  JSONStorage.swift
//  ChronosApp
//
//  Created by Петя on 12.10.2026.
//
import Foundation

struct JSONStorage{
    
    
    func saveToJSONFile(homeworks: [Homework]){
        do{
            let encoder = JSONEncoder() //json
            let data = try encoder.encode(homeworks)// try encode our homeworks in byte subsequence
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // get [url]
            guard let firstURL = urls.first else{ // get url
                return
            }
            let fileURL = firstURL.appendingPathComponent("homeworks.json") // appending component
            try data.write(to: fileURL) // write our data bytes
        }
        catch{
            print(error)
        }
    }
    
    func loadFromJSONFile() -> [Homework]{
        do{
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            guard let firstURL = urls.first else{
                return []
            }
            let fileURL = firstURL.appendingPathComponent("homeworks.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let dataJSON = try decoder.decode([Homework].self, from: data)
            return dataJSON
        }catch{
            print(error)
            return []
        }
    }
    
}
