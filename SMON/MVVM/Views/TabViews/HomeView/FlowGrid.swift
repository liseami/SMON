//
//  StaggeredLayout.swift
//  StaggeredList
//
//  Created by Alfian Losari on 13/10/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct StaggeredLayout {
    
    let containerSize: CGSize
    let numberOfColumns: Int
    let columnWidth: CGFloat
    let xOffsets: [CGFloat]
    var maxY: CGFloat = 0
    private var currentColumn = 0
    private var yOffsets = [CGFloat]()

    private let sectionInset: EdgeInsets
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    
    init(containerSize: CGSize, numberOfColumns: Int = 2, horizontalSpacing: CGFloat = 2, verticalSpacing: CGFloat = 2, sectionInset: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)) {
        assert(numberOfColumns > 0, "Number of columns minimal is 1")
        
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.sectionInset = sectionInset
        self.containerSize = containerSize
        self.numberOfColumns = numberOfColumns
        
        let totalHorizontalSpacingWidth = CGFloat(numberOfColumns - 1) * horizontalSpacing
        let insetsWidth = sectionInset.leading + sectionInset.trailing
        columnWidth = (containerSize.width - totalHorizontalSpacingWidth - insetsWidth) / CGFloat(numberOfColumns)
        var xOffsets = [CGFloat]()
        var x: CGFloat = 0
        
        for col in 0..<numberOfColumns {
            x = sectionInset.leading + (CGFloat(col) * (columnWidth + horizontalSpacing))
            xOffsets.append(x)
        }
        
        self.xOffsets = xOffsets
        self.yOffsets = .init(repeating: sectionInset.top, count: numberOfColumns)
    }
    
    mutating func add(element size: CGSize) -> CGRect {
        if currentColumn > numberOfColumns - 1 {
            currentColumn = 0
        }
        
        defer {
            currentColumn += 1
        }
        
        let y = yOffsets[currentColumn]
        yOffsets[currentColumn] = y + size.height + verticalSpacing
        maxY = max(maxY, yOffsets[currentColumn])
        return CGRect(x: xOffsets[currentColumn], y: y, width: columnWidth, height: size.height)
    }
    
    var size: CGSize {
        return CGSize(width: containerSize.width, height: maxY + sectionInset.bottom)
    }
}


//
//  StaggeredList.swift
//  StaggeredList
//
//  Created by Alfian Losari on 13/10/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

// Inspired By SwiftTalk (objc.io) on Building Collection View
// https://talk.objc.io/episodes/S01E168-building-a-collection-view-part-2

import SwiftUI

public struct StaggeredLayoutList<Elements, Content>: View where Elements: RandomAccessCollection, Elements.Element: Identifiable, Content: View {
    
    public var data: Elements
    public var numberOfColumns: Int
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    public var sectionInsets: EdgeInsets
    public var content: (Elements.Element) -> Content
    @State private var sizes: [Elements.Element.ID: CGSize] = [:]
    
    public init(data: Elements, numberOfColumns: Int = 2, horizontalSpacing: CGFloat = 2, verticalSpacing: CGFloat = 2, sectionInsets: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8), content: @escaping (Elements.Element) -> Content ) {
        self.data = data
        self.numberOfColumns = numberOfColumns
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.sectionInsets = sectionInsets
        self.content = content
    }
    
    private func calculateLayout(containerSize: CGSize) -> (offsets: [Elements.Element.ID: CGSize], contentHeight: CGFloat, columnWidth: CGFloat) {
        var state = StaggeredLayout(containerSize: containerSize, numberOfColumns: numberOfColumns, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing, sectionInset: sectionInsets)
        var result: [Elements.Element.ID: CGSize] = [:]
        for element in data {
            let rect = state.add(element: sizes[element.id] ?? .zero)
            result[element.id] = CGSize(width: rect.origin.x, height: rect.origin.y)
        }
        return (result, state.maxY, state.columnWidth)
    }
    
    private func bodyHelper(containerSize: CGSize, layout: (offsets: [Elements.Element.ID: CGSize], contentHeight: CGFloat, columnWidth: CGFloat)) -> some View {
        LazyVStack {
            ScrollView {
                ZStack(alignment: Alignment.topLeading) {
                    ForEach(self.data) {
                        PropagateSize(content: self.content($0), id: $0.id, containerSize: containerSize, columnWidth: layout.columnWidth)
                            .offset(layout.offsets[$0.id] ?? CGSize.zero)
                    }
                    .animation(.default)
                    Color.clear.frame(width: containerSize.width, height: layout.contentHeight)
                }
            }
            .onPreferenceChange(StaggeredViewSizeKey.self) {
                self.sizes = $0
            }
            .frame(width: containerSize.width, height: containerSize.height)
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            self.bodyHelper(containerSize: proxy.size, layout: self.calculateLayout(containerSize: proxy.size))
        }
    }
}

private struct PropagateSize<V: View, ID: Hashable>: View {
    
    var content: V
    var id: ID
    var containerSize: CGSize
    var columnWidth: CGFloat
    
    var body: some View {
        content
            .frame(width: columnWidth)
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: StaggeredViewSizeKey.self, value: [self.id: proxy.size])
            })
    }
}

private struct StaggeredViewSizeKey<ID: Hashable>: PreferenceKey {
    typealias Value = [ID: CGSize]
    
    static var defaultValue: [ID: CGSize] { [:] }
    static func reduce(value: inout [ID: CGSize], nextValue: () -> [ID: CGSize]) {
        value.merge(nextValue(), uniquingKeysWith: {$1})
    }
    
}
