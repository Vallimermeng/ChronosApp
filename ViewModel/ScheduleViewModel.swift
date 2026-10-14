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
    
    init(){
        homeworks = jsonStorage.loadFromJSONFile()
    }
//    var homeworks = [
//        Homework(name: "Лабораторная №1", description: "ОТУ защита", day: .tuesday, status: .notStarted, week: 1, submissionWeek: 8),
//        Homework(name: "Лаба БД 3", description: "отчет", day: .wednesday, status: .completed, week: 3, submissionWeek: 6),
//        Homework(name: "Лаба БД 2", description: "отчет", day: .wednesday, status: .started, week: 2, submissionWeek: 6),
//        Homework(name: "Лаба БД 4", description: "отчет", day: .monday, status: .started, week: 2, submissionWeek: 6)
//    ]
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
            homeworks.remove(at: id)
            saveHomeworks()
        }
    }
    
    private func saveHomeworks(){
        jsonStorage.saveToJSONFile(homeworks: homeworks)
    }
    
    
}

