//
//  MainScreenView.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 25.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import SwiftUI


struct MainScreenView: View {
    
    @State private var isDefaultData = true
    @State private var selectedAlgorithmIndex: Int = 0
    @State private var zoomValue: Float = 1
    @State private var lenghtOfProductionLine: CGFloat = 0
    @State private var items: [Detail] = []
    @State private var filePath: String = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                TextField("Enter file path", text: $filePath)
                
                Button.init("Load data from file") {
                    self.items = DataLoader.sharedInstance.parse(string: DataLoader.sharedInstance.readAll(file: self.filePath)!)
                }.alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("I/O Error!"), message: Text("Invalid file path!"), dismissButton: .default(Text("Close")))
                }
                .padding()
                
                Button.init("Load default data") {
                    self.items = DataLoader.sharedInstance.parse(string: DataLoader.sampleFileData)
                }.padding()
                
            }.frame(alignment: .center)
            
            
            ScrollView(.horizontal) {
                Picker(selection: $selectedAlgorithmIndex, label: Text("Выберите алгоритм")) {
                    Text("Базовый").tag(0)
                    Text("Джонсон 1").tag(1)
                    Text("Джонсон 2").tag(2)
                    Text("Джонсон 3").tag(3)
                    Text("Джонсон 4").tag(4)
                    Text("Джонсон 5").tag(5)
                    Text("Петрова-Соколицына 1").tag(6)
                    Text("Петрова-Соколицына 2").tag(7)
                    Text("Петрова-Соколицына 3").tag(8)
                }.pickerStyle(SegmentedPickerStyle()).padding(.bottom, 30.0).fixedSize(horizontal: false, vertical: true)
            }
            
            HStack {
                HStack {
                    Text("Zoom")
                    Slider(value: $zoomValue, in: (0.2)...3)
                }.padding()
                
                Text("Длина цикла: \(Int(lenghtOfProductionLine))")
            }
            
            GanttCollectionView(items: $items, zoomValue: $zoomValue, algorithmIndex: $selectedAlgorithmIndex) { length in
                self.lenghtOfProductionLine = length
            }
            
        }.padding()
    }
    
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
