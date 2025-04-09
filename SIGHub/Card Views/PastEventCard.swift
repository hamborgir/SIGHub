//
//  PastEventCard.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 08/04/25.
//

import SwiftUI

struct PastEventCard: View {
    let event: EventModel

    var body: some View {
        HStack(spacing: 10) {
            Text(event.image)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(event.name)
                    .font(.headline)

                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {}) {
                    Text(event.SIG!.category)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    PastEventCard(event: EventModel.getSample())
}
