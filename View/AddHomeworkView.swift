//
//  AddHomeworkView.swift
//  ChronosApp
//
//  Created by Петя on 10.10.2026.
//

import SwiftUI


struct AddHomeworkView: View{
    var viewModel: ScheduleViewModel
    private let photoStorage = PhotoStorage()
    @Environment(\.dismiss) var dismiss
    
    @State private var inputName: String = ""
    @State private var inputDescription: String = ""
    @State private var day: Day = .monday
    @State private var status: HomeworkStatus = .notStarted
    @State private var inputWeek: Int = 1
    @State private var inputSubmissionWeek: Int = 1
    
    
    @State private var loadedImage: [Data] = []
    
    var body: some View{
        
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
            
            
            Picker("Статус", selection: $status){
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
            
            
            PhotoPickerView(loadedImage: $loadedImage)
            
            
            Divider()
            
            Button("Сохранить"){
                var photoIDs: [UUID] = []
                do{
                    for dataImage in loadedImage {
                        let photoID = try photoStorage.savePhoto(data: dataImage)
                        
                        photoIDs.append(photoID)
                        
                        
                    }
                    
                    viewModel.addHomework(homework: Homework(name: inputName, description: inputDescription, day: day, status: status, week: inputWeek, submissionWeek: inputSubmissionWeek, photoIDs: photoIDs))
                    dismiss()
                    
                }catch{
                    print(error)
                }
            }
            .padding()
            
            
            
        }
        
    }
}
    


#Preview {
    AddHomeworkView(viewModel: ScheduleViewModel())
}
