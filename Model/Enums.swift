//
//  Enums.swift
//  ChronosApp
//
//  Created by Петя on 07.10.2026.
//

import Foundation


enum Day: String, CaseIterable, Hashable, Codable{
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
}

enum HomeworkStatus: String, CaseIterable, Hashable, Codable{
    case notStarted = "Не начато"
    case started = "Начато"
    case completed = "Выполнено"
}

enum HomeworkFilter: String, CaseIterable, Hashable{
    case all = "Все"
    case notStarted = "Не начато"
    case started = "Начато"
    case completed = "Выполнено"
}
