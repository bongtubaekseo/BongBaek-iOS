//
//  Guide.swift
//  BongBaek
//
//  Created by 임재현 on 11/7/25.
//

import Foundation

struct Guide: Identifiable, Equatable {
    let id: UUID
    let category: ScheduleCategory
    let title: String
    let date: String // 연월일
    let backgroundImage: String // 이미지 이름
    
    init(
        id: UUID = UUID(),
        category: ScheduleCategory,
        title: String,
        date: String,
        backgroundImage: String
    ) {
        self.id = id
        self.category = category
        self.title = title
        self.date = date
        self.backgroundImage = backgroundImage
    }
}

// MARK: - Mock Data
extension Guide {
    static let mockGuides: [Guide] = [
        Guide(
            category: .wedding,
            title: "김철수 ❤️ 이영희 결혼식",
            date: "2025.11.15",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .funeral,
            title: "故 박진수님 장례식",
            date: "2025.11.10",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .birthday,
            title: "할머니 80세 생신",
            date: "2025.11.20",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .babyParty,
            title: "조카 백일잔치",
            date: "2025.11.25",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .birthday,
            title: "친구 개업 축하",
            date: "2025.11.18",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .wedding,
            title: "동생 결혼식",
            date: "2025.12.05",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .birthday,
            title: "아버지 환갑잔치",
            date: "2025.12.10",
            backgroundImage: "ios_article"
        ),
        Guide(
            category: .babyParty,
            title: "첫째 돌잔치",
            date: "2025.12.15",
            backgroundImage: "ios_article"
        )
    ]
}

