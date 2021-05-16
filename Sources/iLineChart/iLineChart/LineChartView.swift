//
//  LineCard.swift
//  iLineChart
//
//  Created by András Samu on 2019. 08. 31..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI
import iColor

struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: ChartData
    public var title: String?
    public var legend: String?
    public var timePeriodText: String
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    var indicatorKnob: Color
    
    private var rawData: [Double]
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    public var curvedLines: Bool
    public var displayChartStats: Bool
    
    public var minWidth: CGFloat
    public var minHeight: CGFloat
    public var maxWidth: CGFloat
    public var maxHeight: CGFloat
    
    public var titleFont: Font
    public var subtitleFont: Font
    public var priceFont: Font
    
    private var contentHeight: CGFloat = 0
    private var topPadding: CGFloat = 0
    private var edgesIgnored: Edge.Set
    
    @State private var showHighAndLowValues: Bool = true
    @State private var minimumPoint: CGPoint?
    @State private var maximumPoint: CGPoint?
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
        }
    }
    
    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?
    
    private var changeInValue: Double {
        guard let firstValue = data.onlyPoints().first else {
            return 0.0
        }
        return currentValue - firstValue
    }
    
    var priceColor: Color {
        if changeInValue >= 0 {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    private var minimumValue: Double {
        return self.data.onlyPoints().min() ?? 0
    }
    
    private var maximumValue: Double {
        return self.data.onlyPoints().max() ?? 0
    }
    
    init(data: [Double],
         title: String? = nil,
         legend: String? = nil,
         style: ChartStyle = Styles.lineChartStyleOne,
         form: CGSize? = ChartForm.extraLarge,
         rateValue: Int? = 14,
         dropShadow: Bool? = false,
         valueSpecifier: String? = "%.1f",
         cursorColor: Color = Color.neonPink,
         curvedLines: Bool = true,
         displayChartStats: Bool = true,
         minWidth: CGFloat = 0,
         minHeight: CGFloat = 0,
         maxWidth: CGFloat = .infinity,
         maxHeight: CGFloat = .infinity,
         titleFont: Font = .system(size: 30, weight: .regular, design: .rounded),
         subtitleFont: Font = .system(size: 14, weight: .light, design: .rounded),
         priceFont: Font = .system(size: 16, weight: .bold, design: .monospaced),
         fullScreen: Bool = false,
         showHighAndLowValues: Bool = true,
         timePeriodText: String = ""
    ) {
        
        self.rawData = data
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        //        self.formSize = CGSize(width: width, height: height)
        //        self.width = width
        //        self.height = height
        //        frame = CGSize(width: width, height: height)
        // MARK: DEBUG
        self.formSize = CGSize(width: maxWidth, height: maxHeight)
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        frame = CGSize(width: maxWidth, height: maxHeight)
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.rateValue = rateValue
        self.indicatorKnob = cursorColor
        self.curvedLines = curvedLines
        self.displayChartStats = displayChartStats
        self.subtitleFont = subtitleFont
        self.titleFont = titleFont
        self.priceFont = priceFont
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.timePeriodText = timePeriodText
        
        self.edgesIgnored = fullScreen ? .all : .bottom
    }
    
    private var internalRate: Int? {
        if (self.rawData.count > 0) && (self.rawData.first! == 0) {
            return nil
        }
        
        if !self.showIndicatorDot {
            if self.rawData.count > 1 {
                return Int(((self.rawData.last!/self.rawData.first!) - 1)*100)
            } else {
                return nil
            }
        } else {
            if self.rawData.count > 1 {
                return Int(((self.currentValue/self.rawData.first!) - 1)*100)
            } else {
                return nil
            }
        }
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .center) {
                if (self.edgesIgnored == .all) {
                    Rectangle()
                        .fill(self.style.backgroundColor)
                        .edgesIgnoringSafeArea(self.edgesIgnored)
                }
                
                //                VStack(
                //                    alignment: .leading,
                //                    spacing: 20,
                //                    content: {
                //                        Text("Bitcoin Price")
                //                            .foregroundColor(.riverGold)
                //                            .bold()
                //
                //                        if let selectedPrice = self.selectedValue {
                //                            Text(selectedPrice.formattedString)
                //                                .foregroundColor(.white)
                //                                .font(.title)
                //                                .bold()
                //                        } else {
                //                            Text(currentPrice.formattedString)
                //                                .foregroundColor(.white)
                //                                .font(.title)
                //                                .bold()
                //                        }
                //
                //                        let priceChange = currentPrice - previousPrice
                //                        let percentagePriceChg = (priceChange / previousPrice ) * 100
                //                        let percentagePriceChgStr = String(format: "(%.1f%%)", percentagePriceChg)
                //                        let changeColor: Color = priceChange >= 0 ? Color.green : Color.red
                //                        let changeSign: String = priceChange >= 0 ? "+" : ""
                //                        let firstText = "\(changeSign)\(priceChange.formattedString) \(percentagePriceChgStr)"
                //
                //                        HStack(
                //                            alignment: .center,
                //                            spacing: 4,
                //                            content: {
                //                                Text(firstText)
                //                                    .foregroundColor(changeColor)
                //                                    .font(.subheadline)
                //                                    .bold()
                //                                if selectedValue == nil {
                //                                    Text(currentTimePeriod.priceChangeText)
                //                                        .foregroundColor(.white)
                //                                        .font(.subheadline)
                //                                        .bold()
                //                                }
                //                            }
                //                        )
                //                    }
                //                )
                //                .padding(.top, 12)
                //                .padding(.bottom, 12)
                //                .padding(.leading, 20)
                //                .frame(alignment: .leading)
                //                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading) {
                    if ((self.title != nil) || (self.legend != nil) || (self.displayChartStats)) {
                        VStack(alignment: .leading, spacing: 20){
                            if (self.title != nil) {
                                Text(self.title!)
                                    .font(self.titleFont)
                                    .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                            }
                            
                            HStack {
                                if ((self.displayChartStats)) {
                                    if (self.showIndicatorDot) {
                                        if (self.internalRate != nil) {
                                            Text("\(String(format: self.valueSpecifier, self.currentValue))")
                                        } else {
                                            Text("\(String(format: self.valueSpecifier, self.currentValue))")
                                        }
                                    } else if (self.rawData.last != nil) {
                                        if (self.internalRate != nil) {
                                            Text("\(String(format: self.valueSpecifier, self.rawData.last!))")
                                        } else {
                                            Text("\(String(format: self.valueSpecifier, self.rawData.last!))")
                                        }
                                    } else if (self.internalRate != nil) {
                                        Text("(\(self.internalRate!)%)")
                                    } else {
                                        Text("nil")
                                    }
                                }
                            }
                            .font(self.subtitleFont)
                            .foregroundColor(Color.white)
                            
                            HStack {
                                if ((self.displayChartStats)) {
                                    if (self.showIndicatorDot) {
                                        if (self.internalRate != nil) {
                                            Text("\(String(format: self.valueSpecifier, self.changeInValue)) (\(self.internalRate!)%)")
                                                .font(self.priceFont)
                                                .foregroundColor(self.priceColor)
                                        } else {
                                            Text("\(String(format: self.valueSpecifier, self.changeInValue))")
                                                .font(self.priceFont)
                                                .foregroundColor(self.priceColor)
                                        }
                                    } else if (self.rawData.last != nil &&
                                               self.rawData.first != nil) {
                                        if (self.internalRate != nil) {
                                            HStack {
                                                Text("\(String(format: self.valueSpecifier, (self.rawData.last! - self.rawData.first!))) (\(self.internalRate!)%)")
                                                    .font(self.priceFont)
                                                    .foregroundColor(self.priceColor)
                                                Text("\(self.timePeriodText)")
                                                    .font(self.priceFont)
                                                    .foregroundColor(Color.white)
                                            }
                                        } else {
                                            HStack {
                                                Text("\(String(format: self.valueSpecifier, (self.rawData.last! - self.rawData.first!)))  \(self.timePeriodText)")
                                                    .font(self.priceFont)
                                                    .foregroundColor(self.priceColor)
                                                Text("\(self.timePeriodText)")
                                                    .font(self.priceFont)
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    } else if (self.internalRate != nil) {
                                        Text("(\(self.internalRate!)%)")
                                    } else {
                                        Text("nil")
                                    }
                                }
                            }
                            .font(self.priceFont)
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.1))
                        .padding([.leading, .top])
                        .padding(.top, self.topPadding)
                    }
                    
                    
                    GeometryReader{ geometry in
                        Line(data: self.data,
                             frame: .constant(geometry.frame(in: .local)),
                             touchLocation: self.$touchLocation,
                             showIndicator: self.$showIndicatorDot,
                             minDataValue: .constant(nil),
                             maxDataValue: .constant(nil),
                             lineGradient: self.style.lineGradient,
                             backgroundGradient: self.style.backgroundGradient,
                             indicatorKnob: self.indicatorKnob,
                             curvedLines: self.curvedLines
                        )
                        
                        if showHighAndLowValues {
                            let minimumPoint = self.getMinimumDataPoint(width: geometry.frame(in: .local).size.width - 20,
                                                                        height: geometry.frame(in: .local).size.height)
                            let maximumPoint = self.getMaximumDataPoint(width: geometry.frame(in: .local).size.width - 40,
                                                                        height: 0)
                            
                            Text("\(self.minimumValue.formattedCurrencyString)")
                                .offset(x: minimumPoint.x,
                                        y: minimumPoint.y)
                                .foregroundColor(Color.white)
                                .font(.bold(.title3)())
                            
                            Text("\(self.maximumValue.formattedCurrencyString)")
                                .offset(x: maximumPoint.x,
                                        y: maximumPoint.y)
                                .foregroundColor(Color.white)
                                .font(.bold(.title3)())
                        }
                    }
                    .frame(minWidth: self.minWidth, maxWidth: self.maxWidth, minHeight: self.minHeight, maxHeight: self.maxHeight)
                    .padding(.bottom)
                    .onAppear {
                        
                    }
                    
                    
                    // MARK: Frames
                    //                .clipShape(RoundedRectangle(cornerRadius: 0))
                    
                }
                .background(self.style.backgroundColor)
                .frame(width: (self.maxWidth == .infinity ? g.size.width : self.maxWidth), height: (self.maxHeight == .infinity ? g.size.height : self.maxHeight))
                
                
            }
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.touchLocation = value.location
                            self.showIndicatorDot = true
                            self.showHighAndLowValues = false
                            // MARK: Frames
                            self.getClosestDataPoint(toPoint: value.location,
                                                     width:(self.maxWidth == .infinity ? g.size.width : self.maxWidth),
                                                     height:(self.maxHeight == .infinity ? g.size.height : self.maxHeight))
                        })
                        .onEnded({ value in
                            self.showIndicatorDot = false
                            self.showHighAndLowValues = true
                        })
                     // MARK: Frames
                     
            )
        }
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
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
        
        if (indexOfMinPoint >= 0 && indexOfMinPoint < points.count){
            return CGPoint(x: CGFloat(indexOfMinPoint)*stepWidth,
                           y: height)
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
        
        if (indexOfMaxPoint >= 0 && indexOfMaxPoint < points.count){
            return CGPoint(x: CGFloat(indexOfMaxPoint)*stepWidth,
                           y: 0)
        }
        return .zero
    }
    
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Basic")
                .environment(\.colorScheme, .light)
        }
    }
}
