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
    
    var body: some View {
        Text("")
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
    }
    
    init(SIGList: [SIGModel]) {
        self.SIGList = SIGList
    }
    
    init() {
        self.SIGList = SIGModel.getData()
    }
}

#Preview {
    SIGListView()
}
