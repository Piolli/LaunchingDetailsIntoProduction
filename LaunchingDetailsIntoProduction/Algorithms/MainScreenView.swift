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
    @State private var selectedAlgorithm = 0
    @State private var zoomValue: Float = 1
    @State private var lenghtOfProductionTime: Int = 0
    @State private var items: [Detail] = [
        .init(1, timeOnMachines: [4, 5]),
        .init(2, timeOnMachines: [4, 1]),
        .init(3, timeOnMachines: [30, 4]),
        .init(4, timeOnMachines: [6, 30]),
        .init(5, timeOnMachines: [2, 3]),
    ]
     
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Button.init("Load data from file") {
                    
                }.padding()
                
                Button.init("Load default data") {
                    
                }.padding()
            }.frame(alignment: .center)
            
            
            ScrollView(.horizontal) {
                Picker(selection: $selectedAlgorithm, label: Text("Выберите алгоритм")) {
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
                
                Text("Длина цикла: \(lenghtOfProductionTime)")
            }
            
            
            GanttCollectionView(items: $items, zoomValue: $zoomValue)
            
            
        }.padding()
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
