//
//  DetailView.swift
//  ChronosApp
//
//  Created by Петя on 10.10.2026.
//

import SwiftUI

struct DetailView: View{
    @Environment(\.dismiss) var dismiss
    var homework: Homework
    var viewModel: ScheduleViewModel
    
    private var currentHomework: Homework{ viewModel.homeworks.first(where: {$0.id == homework.id}) ?? homework}
    
    
    
    
    private var statusBinding: Binding<HomeworkStatus>{
        Binding(
            get:{
                return currentHomework.status
            },
            set:{newStatus in
                viewModel.editStatus(homeworkID: currentHomework.id, newStatus: newStatus)
            }
        )
    }
    
    @State private var isEditing: Bool = false
    
    
    @State private var inputName: String = ""
    @State private var inputDescription: String = ""
    @State private var day: Day = .monday
    @State private var inputWeek: Int = 1
    @State private var inputSubmissionWeek: Int = 1
    
    private var statusColor: Color{
        switch currentHomework.status{
            
        case .notStarted:
            return .red
        case .started:
            return .orange
        case .completed:
            return .green
        }
    }
    
    var body: some View{
        
        VStack{
            
            
            if(!isEditing){
                Text(currentHomework.name)
                    .font(.headline)
                Text("Описание: \(currentHomework.description)")
                    .font(.subheadline)
                Text("День сдачи: \(currentHomework.day.rawValue)")
                    .font(.subheadline)
                HStack{
                    Text("Статус ДЗ: ")
                        .font(.subheadline)
                    
                    Picker("Статус", selection: statusBinding){
                        ForEach(HomeworkStatus.allCases, id:\.self){status in
                            Text(status.rawValue)
                                .tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundStyle(.black)
                    .background(statusColor.opacity(0.3))
                    .clipShape(Capsule())
                    
                    
                }
                Text("Неделя начала выполнения: \(currentHomework.week)")
                    .font(.subheadline)
                Text("Неделя сдачи: \(currentHomework.submissionWeek)")
                    .font(.subheadline)
                
                
                Button("Редактировать"){
                    isEditing.toggle()
                    inputName = currentHomework.name
                    inputDescription = currentHomework.description
                    day = currentHomework.day
                    inputWeek = currentHomework.week
                    inputSubmissionWeek = currentHomework.submissionWeek
                    
                }
                
                Button("Удалить ДЗ"){
                    viewModel.deleteHomework(homeworkID: currentHomework.id)
                    dismiss()
                }
                
                Button("Отмена"){
                    dismiss()
                }
            }
            
            //BAD - code repeatability from AddHomeworkView (TODO: FIX)
            if(isEditing){
                VStack{
                    TextField("Название", text: $inputName)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Описание", text: $inputDescription)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("День недели", selection: $day){
                        ForEach(Day.allCases, id: \.self){day in
                            Text(day.rawValue)
                                .tag(day)
                        }
                    }
                    Divider()
                    
                    
                    Picker("Статус", selection: statusBinding){
                        ForEach(HomeworkStatus.allCases, id: \.self){status in
                            Text(status.rawValue)
                                .tag(status)
                        }
                    }
                    Divider()
                    
                    HStack{
                        Text("Неделя начала выполнения")
                            .font(.subheadline)
                        Picker("Неделя", selection: $inputWeek){
                            ForEach(1..<19){week in
                                Text("\(week)")
                                    .tag(week)
                            }
                        }
                    }
                    Divider()
                    
                    HStack{
                        Text("Неделя сдачи")
                            .font(.subheadline)
                        Picker("Неделя сдачи", selection: $inputSubmissionWeek){
                            ForEach(1..<19){week in
                                Text("\(week)")
                                    .tag(week)
                            }
                        }
                    }
                    Divider()
                    
                    Button("Сохранить"){
                        viewModel.editHomework(homeworkID: currentHomework.id, homework: Homework(name: inputName, description: inputDescription, day: day, status: currentHomework.status, week: inputWeek, submissionWeek: inputSubmissionWeek, id: currentHomework.id))
                        isEditing = false
                    }
                    
                    Button("Отмена"){
                        isEditing.toggle()
                    }
                    
                }
                
            }
            
            
            
            
        }
        
    }
    
    
}


#Preview {
    DetailView(homework: Homework(name: "Лабораторная №1", description: "ОТУ защита", day: .tuesday, status: .started, week: 1, submissionWeek: 8), viewModel: ScheduleViewModel())
}
