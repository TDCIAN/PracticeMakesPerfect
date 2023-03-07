//
//  MoodDiaryCell.swift
//  EmotionDiary
//
//  Created by JeongminKim on 2023/03/07.
//

import SwiftUI

struct MoodDiaryCell: View {
    
    var diary: MoodDiary
    
    var body: some View {
        Image(systemName: diary.mood.imageName)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .shadow(
                color: .black.opacity(0.2),
                radius: 10,
                x: 0,
                y: 0
            )
    }
}
