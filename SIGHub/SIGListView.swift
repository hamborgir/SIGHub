//
//  SIGListView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 30/03/25.
//

import SwiftUI

struct SIGListView: View {
//    var categorizedSIGList: [String : [SIGModel]]
//    var category: String
    var SIGList: [SIGModel]
    var category: String
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(SIGList, id:\.self) {SIG in
                    NavigationLink(value: SIG) {
                        VStack {
                            SIGListObjectView(SIG)
                            Divider()
                                .frame(width: 300)
                        }
                    }
                }
                
            }
            .navigationTitle(category)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    init(SIGList: [SIGModel], category: String) {
        self.SIGList = SIGList
        self.category = category
    }
    
    init() {
        self.SIGList = SIGModel.getData()
        self.category = ""
    }
}

#Preview {
    SIGListView()
}
