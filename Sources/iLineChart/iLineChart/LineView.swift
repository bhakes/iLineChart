//
//  LineView.swift
//  iLineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct LineView: View {
    @ObservedObject var data: ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var numberFormat:String
    
    private var minimumValue: Double {
        return self.data.onlyPoints().min() ?? 0
    }
    
    private var maximumValue: Double {
        return self.data.onlyPoints().max() ?? 0
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    
    @State private var minimumPoint: CGPoint?
    @State private var maximumPoint: CGPoint?
    @State private var opacity:Double = 0
    @State private var currentDataNumber: Double = 0
    @State private var hideHorizontalLines: Bool = false
    @State private var showHighAndLowValues: Bool = true
    private var defaultHorizontalLines: Bool = false
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                numberFormat: String? = "%.1f",
                hideHorizontalLines: Bool = false,
                showHighAndLowValues: Bool = true) {
        self.defaultHorizontalLines = hideHorizontalLines
        self._hideHorizontalLines = State(initialValue: hideHorizontalLines)
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.numberFormat = numberFormat!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.showHighAndLowValues = showHighAndLowValues
        
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                            .bold().foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    }
                    if (self.legend != nil){
                        Text(self.legend!)
                            .font(.callout)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }
                }.offset(x: 0, y: 20)
                
                ZStack{
                    GeometryReader { reader in
                        Rectangle()
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                        if(self.showLegend){
                            Legend(data: self.data,
                                   frame: .constant(reader.frame(in: .local)),
                                   hideHorizontalLines: self.$hideHorizontalLines)
                                .transition(.opacity)
                                .animation(Animation.easeOut(duration: 1).delay(1))
                        }
                        
                        let minimumPoint = self.getMinimumDataPoint(width: geometry.frame(in: .local).size.width-30,
                                                                    height: geometry.frame(in: .local).size.height - 270)
                        let maximumPoint = self.getMaximumDataPoint(width: geometry.frame(in: .local).size.width-30,
                                                                    height: -24)
                        
                        if showHighAndLowValues {
                            Text("\(self.minimumValue.formattedCurrencyString)")
                                .offset(x: minimumPoint.x,
                                        y: minimumPoint.y)
                                .foregroundColor(Color.red)
                            
                            Text("\(self.maximumValue.formattedCurrencyString)")
                                .offset(x: maximumPoint.x,
                                        y: maximumPoint.y)
                                .foregroundColor(Color.red)
                        }
                        
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height)),
                             touchLocation: self.$indicatorLocation,
                             showIndicator: self.$hideHorizontalLines,
                             minDataValue: .constant(nil),
                             maxDataValue: .constant(nil),
                             showBackground: false,
                             lineGradient: self.style.lineGradient
                        )
                        .offset(x: 30, y: -20)
                        .onAppear(){
                            self.showLegend = true
                        }
                        .onDisappear(){
                            self.showLegend = false
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 240)
                    .offset(x: 0, y: 40 )
                    MagnifierRect(currentNumber: self.$currentDataNumber,
                                  valueSpecifier: self.numberFormat)
                        .opacity(self.opacity)
                        .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                .gesture(DragGesture()
                            .onChanged({ value in
                                self.dragLocation = value.location
                                self.indicatorLocation = CGPoint(x: max(value.location.x-30,0), y: 32)
                                self.opacity = 1.0
                                self.closestPoint = self.getClosestDataPoint(toPoint: value.location,
                                                                             width: geometry.frame(in: .local).size.width-30,
                                                                             height: 240)
                                self.hideHorizontalLines = true
                            })
                            .onEnded({ value in
                                self.opacity = 0
                                self.hideHorizontalLines = false
                                print(self.defaultHorizontalLines)
                            })
                )
            }
        }
    }
    
    func getClosestDataPoint(toPoint: CGPoint,
                             width:CGFloat,
                             height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
    
    func getMinimumDataPoint(width:CGFloat,
                             height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let pointsEnumerated = points.enumerated()
        guard let indexOfMinPoint = pointsEnumerated.min(by: { $0.element < $1.element })?.offset else {
            return .zero
        }
        
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        if (indexOfMinPoint >= 0 && indexOfMinPoint < points.count){
            self.currentDataNumber = points[indexOfMinPoint]
            return CGPoint(x: CGFloat(indexOfMinPoint)*stepWidth,
                           y: CGFloat(points[indexOfMinPoint])*stepHeight)
        }
        return .zero
    }
    
    func getMaximumDataPoint(width:CGFloat,
                             height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let pointsEnumerated = points.enumerated()
        guard let indexOfMaxPoint = pointsEnumerated.max(by: { $0.element < $1.element })?.offset else {
            return .zero
        }
        
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        if (indexOfMaxPoint >= 0 && indexOfMaxPoint < points.count){
            self.currentDataNumber = points[indexOfMaxPoint]
            return CGPoint(x: CGFloat(indexOfMaxPoint)*stepWidth,
                           y: CGFloat(points[indexOfMaxPoint])*stepHeight)
        }
        return .zero
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            LineView(data: [333.502, 332.495, 331.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188],
                     style: Styles.lineChartStyleOne)
            
        }
    }
}

