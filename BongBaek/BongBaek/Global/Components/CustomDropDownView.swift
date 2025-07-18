//
//  CustomDropDownView.swift
//  BongBaek
//
//  Created by 임재현 on 7/6/25.
//

import SwiftUI

protocol DropdownItem: Identifiable, Hashable {
    var displayText: String { get }
}

struct TextDropdownItem: DropdownItem {
    var id = UUID()
    var title: String

    var displayText: String {
        return title
    }
}

struct CustomDropdown<T: DropdownItem>: View {
    let title: String
    let icon: String?
    let placeholder: String
    let items: [T]
    @Binding var selectedItem: T?
    let isDisabled: Bool

    @State private var isExpanded = false

    init(
        title: String,
        icon: String? = nil,
        placeholder: String = "선택해주세요",
        items: [T],
        selectedItem: Binding<T?>,
        isDisabled: Bool = false
    ) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self.items = items
        self._selectedItem = selectedItem
        self.isDisabled = isDisabled
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                HStack {
                    if let icon = icon {
                        Image(icon)
                        //                            .renderingMode(.template)
                        //                            .foregroundColor(.blue)
                    }
                    Text(title)
                        .bodyMedium14()
                        .foregroundColor(.white)
                }
            }

            VStack(spacing: 0) {
                DropdownHeader()

                if isExpanded {
                    DropdownContent()
                }
            }
            .padding(.top, 8)
        }
    }

    private func DropdownHeader() -> some View {
        Button(action: {
            if !isDisabled {  // 비활성화 상태에서는 터치 무시
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
        }) {
            HStack {
                if let selectedItem = selectedItem {
                    Text(selectedItem.displayText)
                        .foregroundColor(isDisabled ? .white : .white)
                } else {
                    Text(placeholder)
                        .foregroundColor(isDisabled ? .gray600 : .gray)
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .frame(height: 50)
            .padding(.horizontal, 16)
            .background(Color.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        (selectedItem != nil || isExpanded)
                            ? Color("primary_normal") : Color("gray750"),
                        lineWidth: 1
                    )
            )
            .cornerRadius(8)
        }
        .disabled(isDisabled)
    }

    private func DropdownContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items, id: \.id) { item in
                Button(action: {
                    selectedItem = item
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8))
                    {
                        isExpanded = false
                    }
                }) {
                    HStack {
                        Text(item.displayText)
                            .foregroundColor(
                                selectedItem?.id == item.id
                                    ? Color("primary_normal") : .white
                            )

                        Spacer()

                        if selectedItem?.id == item.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("primary_normal"))
                        }
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .background(
                        selectedItem?.id == item.id
                            ? Color("primary_normal").opacity(0.1)
                            : Color.clear
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                if item.id != items.last?.id {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                }
            }
        }
        .background(.gray750)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("primary_normal"), lineWidth: 1)
        )
        .cornerRadius(8)
        .transition(
            .asymmetric(
                insertion: .scale(scale: 0.95, anchor: .top).combined(
                    with: .opacity
                ),
                removal: .scale(scale: 0.95, anchor: .top).combined(
                    with: .opacity
                )
            )
        )
    }
}

struct DropdownView: View {
    @State private var selectedEvent: TextDropdownItem?
    @State private var selectedRelation: TextDropdownItem?

    let eventItems = [
        TextDropdownItem(title: "결혼"),
        TextDropdownItem(title: "장례"),
        TextDropdownItem(title: "생일"),
        TextDropdownItem(title: "돌잔치"),
        TextDropdownItem(title: "승진"),
        TextDropdownItem(title: "개업"),
    ]

    let relationItems = [
        TextDropdownItem(title: "가족"),
        TextDropdownItem(title: "친구"),
        TextDropdownItem(title: "직장동료"),
        TextDropdownItem(title: "선후배"),
        TextDropdownItem(title: "이웃"),
        TextDropdownItem(title: "기타"),
    ]

    var body: some View {
        VStack(spacing: 24) {
            CustomDropdown(
                title: "관계",
                icon: "person.2.circle",
                placeholder: "관계를 선택하세요",
                items: relationItems,
                selectedItem: $selectedRelation
            )

            CustomDropdown(
                title: "경조사",
                icon: "icon_event_16",
                placeholder: "경조사를 선택하세요",
                items: eventItems,
                selectedItem: $selectedEvent
            )
        }
        .padding()
        .background(Color.background)
    }
}
