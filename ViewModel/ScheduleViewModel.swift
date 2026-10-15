//
//  ScheduleViewModel.swift
//  ChronosApp
//
//  Created by Петя on 10.10.2026.
//

import Foundation
import Observation


@Observable
class ScheduleViewModel{
    let jsonStorage = JSONStorage()
    
    var homeworks: [Homework]
    private var photoStorage = PhotoStorage()
    
    init(){
        homeworks = jsonStorage.loadFromJSONFile()
    }

    var selectedWeek: Int = 1
    var selectedFilter: HomeworkFilter = .all
    
    
    func addHomework(homework: Homework){
        homeworks.append(homework)
        saveHomeworks()
    }
    
    func filter(day: Day) -> [Homework]{
        let filter = homeworks.filter{homework in
            homework.week == selectedWeek && homework.day == day && (selectedFilter == .all || homework.status.rawValue == selectedFilter.rawValue)
        }
        
        return filter // фильтр
    }
    
    func editStatus(homeworkID: UUID, newStatus: HomeworkStatus){
        if let id = homeworks.firstIndex(where:{ homework in
            homework.id == homeworkID // homework object
        }){
            homeworks[id].status = newStatus
            saveHomeworks()
        }
        
    }
    
    func editHomework(homeworkID: UUID, homework: Homework){
        if let id = homeworks.firstIndex(where: { homework in
            homework.id == homeworkID
            
        }){
            homeworks[id] = homework
            saveHomeworks()
        }
    }
    
    func deleteHomework(homeworkID: UUID){
        if let id = homeworks.firstIndex(where: { homework in
            homework.id == homeworkID
        }){
            
            for photoId in homeworks[id].photoIDs {
                do{
                    try photoStorage.deletePhoto(id: photoId)
                }catch{
                    print(error)
                }
            }
            
            homeworks.remove(at: id)
            
            saveHomeworks()
        }
    }
    
    private func saveHomeworks(){
        jsonStorage.saveToJSONFile(homeworks: homeworks)
    }
    
    
}

