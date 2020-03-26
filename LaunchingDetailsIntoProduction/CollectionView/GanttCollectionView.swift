//
//  GanttCollectionView.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 25.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import SwiftUI

struct GanttCollectionView: UIViewRepresentable {
    
    typealias UIViewType = UIGanttCollectionView
    
    @Binding var items: [Detail]
    @Binding var zoomValue: Float
    @Binding var algorithmIndex: Int
    
    func makeUIView(context: UIViewRepresentableContext<GanttCollectionView>) -> UIGanttCollectionView {
        return UIGanttCollectionView(items: items)
    }
    
    func updateUIView(_ uiView: UIGanttCollectionView, context: UIViewRepresentableContext<GanttCollectionView>) {
        uiView.items = items
        uiView.zoomValue = CGFloat(zoomValue)
        uiView.reorderingAlgorithm = reorderingAlgorithms[algorithmIndex]
    }
    
}

//
//struct GanttCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        GanttCollectionView(items: [], zoomValue: 1)
//    }
//}
