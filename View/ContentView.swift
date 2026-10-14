//
//  ContentView.swift
//  ChronosApp
//
//  Created by Петя on 05.10.2026.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var viewModel = ScheduleViewModel()
    @State private var showAddHomework: Bool = false
    @State private var detailShow: Homework? = nil
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 12){
                
                ForEach(1..<19){week in
                    Button{
                        viewModel.selectedWeek = week
                    }label: {
                        Text("\(week)")
                        
                    }
                    .opacity(week == viewModel.selectedWeek ? 1.0 : 0.5)
                    
                    
                    
                }
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue)
                .cornerRadius(12)
                
                
            }.padding()
        }
        
        HStack{
            Text("Фильтр:")
                .font(.headline)
                
            ForEach(HomeworkFilter.allCases, id: \.self){status in
                Button{
                    viewModel.selectedFilter = status
                }label:{
                    Text(status.rawValue)
                        .padding(.horizontal, 4)
                }
            }
        }
        
        HStack(){
            
            Button(action:{
                showAddHomework.toggle()
            }){
                Label("Добавить", systemImage: "plus.app.fill")
            }
            .padding()
            .sheet(isPresented: $showAddHomework) {
                        AddHomeworkView(viewModel: viewModel)
                    .presentationDetents([.medium, .fraction(0.55), .height(400)])
                    }
            
            
        }
        
        
        
        Spacer()
        
        ScrollView{
            VStack(alignment: .leading) {
                
                
                ForEach(Day.allCases, id: \.self){day in
                    let filter = viewModel.filter(day: day)
                    
                    if(viewModel.selectedFilter == .all){
                        Divider()
                            .background(.black)
                        Text("\(day.rawValue)")
                            .padding()
                            .font(.headline)
                        
                    }
                    
                    ForEach(filter){homework in
                        VStack(alignment: .leading){
                            if(viewModel.selectedFilter != .all){
                                Text("\(day.rawValue)")
                                    .font(.headline)
                            }
                            Text(homework.name)
                                .font(.headline)
                            Text(homework.description)
                                .font(.headline)
                            Text("Сдать на: \(homework.submissionWeek) неделе")
                                .font(.subheadline)
                            
                            switch(homework.status){
                            case .notStarted:
                                Text("Статус: не начато")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.red)
                                    .clipShape(Capsule())
                                
                            case .started:
                                Text("Статус: начато")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.orange)
                                    .clipShape(Capsule())
                                
                            case .completed:
                                Text("Статус: выполнено")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.green)
                                    .clipShape(Capsule())
                            }
                            
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .onTapGesture {
                            detailShow = homework
                        }
                        .sheet(item: $detailShow){homework in
                            DetailView(homework: homework, viewModel: viewModel)
                                .presentationDetents([.medium, .fraction(0.55), .height(330)])
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            .padding()
            
        }
        
        Spacer()
    }
}

#Preview {
    ContentView()
    
}
