//
//  Homework.swift
//  ChronosApp
//
//  Created by Петя on 07.10.2026.
//

import Foundation

struct Homework: Identifiable, Codable{
    var name: String // name of homework
    var description: String
    var day: Day
    var status: HomeworkStatus
    var week: Int
    var submissionWeek: Int
    
    var id: UUID = UUID()
    var photoIDs: [UUID] = []
}
