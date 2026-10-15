//
//  DetailView.swift
//  ChronosApp
//
//  Created by Петя on 10.10.2026.
//

import SwiftUI
import UIKit
import PhotosUI

struct DetailView: View{
    
    @Environment(\.dismiss) var dismiss
    var homework: Homework
    var viewModel: ScheduleViewModel
    private var photoStorage = PhotoStorage()
    
    
    
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
    
    
    
    @State private var isEditing: Bool = false
    
    @State private var inputName: String = ""
    @State private var inputDescription: String = ""
    @State private var day: Day = .monday
    @State private var inputWeek: Int = 1
    @State private var inputSubmissionWeek: Int = 1
    
    
    @State private var loadedImage: [Data] = []
    @State private var loadedImages: [UIImage] = []
    
    
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
                
                
                ForEach(loadedImages.indices, id:\.self){ index in
                    Image(uiImage: loadedImages[index])
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                }
                
                
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
                
                Button("Удалить все фото"){
                    for photoId in currentHomework.photoIDs {
                        do{
                            try photoStorage.deletePhoto(id: photoId)
                        }catch{
                            print(error)
                        }
                    }
                    
                    viewModel.editHomework(homeworkID: currentHomework.id, homework: Homework(name: inputName, description: inputDescription, day: day, status: currentHomework.status, week: inputWeek, submissionWeek: inputSubmissionWeek, id: currentHomework.id, photoIDs: []))
                }
                
                Button("Отмена"){
                    dismiss()
                }
            }
            
            
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
                    
                    ForEach(loadedImages.indices, id:\.self){ index in
                        Image(uiImage: loadedImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                    }
                    
                    
                    PhotoPickerView(loadedImage: $loadedImage)
                    
                    
                    
                    
                    
                    Divider()
                    
                    Button("Сохранить"){
                        var photoIDs: [UUID] = []
                        photoIDs.append(contentsOf: currentHomework.photoIDs)
                        do{
                            for dataImage in loadedImage {
                                let photoID = try photoStorage.savePhoto(data: dataImage)
                                
                                photoIDs.append(photoID)
                            }
                            
                            viewModel.editHomework(homeworkID: currentHomework.id, homework: Homework(name: inputName, description: inputDescription, day: day, status: currentHomework.status, week: inputWeek, submissionWeek: inputSubmissionWeek, id: currentHomework.id, photoIDs: photoIDs))
                            isEditing = false
                        }catch{
                            print(error)
                        }
                    }
                    
                    Button("Отмена"){
                        isEditing.toggle()
                    }
                    
                }
                
            }
        
            
        }
        
        .task{
            loadedImages.removeAll()
            for photoId in currentHomework.photoIDs {
                do{
                    let id = try photoStorage.loadPhoto(id: photoId)
                    if let uiImage = UIImage(data: id){
                        loadedImages.append(uiImage)
                    }
                }catch{
                    print(error)
                }
            }
        }
        
        
        
    }

    
    
}


#Preview {
    DetailView(homework: Homework(name: "Лабораторная №1", description: "ОТУ защита", day: .tuesday, status: .started, week: 1, submissionWeek: 8), viewModel: ScheduleViewModel())
}
