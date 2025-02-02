//
//  File.swift
//  
//
//  Created by Kalil Fine on 9/27/20.
//

import SwiftUI

public struct iLineChart: View {
    public var data: [(date: Date, data: Double)]
    public var headlinePrice: Double
    public var title: String?
    public var subtitle: String?
    public var timePeriodText: String
    public var floatingPointNumberFormat: String
    public var cursorColor: Color
    public var curvedLines: Bool
    public var displayChartStats: Bool
    public var minWidth: CGFloat
    public var minHeight: CGFloat
    public var maxWidth: CGFloat
    public var maxHeight: CGFloat
    
    public var titleFont: Font
    public var subtitleFont: Font
    public var priceFont: Font
    public var fullScreen: Bool
    
    public var shouldShowHighAndLowValues: Bool
    
    private var chartStyle: ChartStyle = Styles.lineChartStyleOne
    private var edgesIgnored: Edge.Set
    static var defaultChartStyle: ChartStyle {
        return Styles.lineChartStyleOne
    }
    
    
    public init (data: [(date: Date, data: Double)],
                 headlinePrice: Double,
                 title: String? = nil,
                 subtitle: String? = nil,
                 style: LineChartStyle? = nil,
                 chartStyle: ChartStyle,
                 lineGradient: GradientColor? = nil,
                 chartBackgroundGradient: GradientColor? = nil,
                 canvasBackgroundColor: Color? = nil,
                 titleColor: Color? = nil,
                 subtitleColor: Color? = nil,
                 numberColor: Color? = nil,
                 curvedLines: Bool = true,
                 cursorColor: Color = Color.pink,
                 displayChartStats: Bool = false,
                 minWidth: CGFloat = 0,
                 minHeight: CGFloat = 0,
                 maxWidth: CGFloat = .infinity,
                 maxHeight: CGFloat = .infinity,
                 titleFont: Font = .system(size: 30, weight: .regular, design: .rounded),
                 subtitleFont: Font = .system(size: 14, weight: .light, design: .rounded),
                 dataFont: Font = .system(size: 16, weight: .bold, design: .monospaced),
                 fullScreen: Bool = false,
                 floatingPointNumberFormat: String = "%.1f",
                 shouldShowHighAndLowValues: Bool = true,
                 timePeriodText: String = ""
                 ) {
        
        
        self.data = data
        self.headlinePrice = headlinePrice
        self.title = title
        self.subtitle = subtitle
        self.timePeriodText = timePeriodText
        self.floatingPointNumberFormat = floatingPointNumberFormat
        self.cursorColor = cursorColor
        self.curvedLines = curvedLines
        self.displayChartStats = displayChartStats
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.maxHeight = maxHeight
        self.maxWidth = maxWidth
        self.subtitleFont = subtitleFont
        self.titleFont = titleFont
        self.priceFont = dataFont
        self.fullScreen = fullScreen
        
        if fullScreen {
            self.edgesIgnored = .all
        } else {
            self.edgesIgnored = .bottom
        }
        
        if let style = style {
            switch style {
            case .primary:
                self.chartStyle = Styles.lineChartStyleTwo
            case .secondary:
                self.chartStyle = Styles.lineChartStyleThree
            case .tertiary:
                self.chartStyle = Styles.lineChartStyleFour
            case .dark:
                self.chartStyle = Styles.darkPrimary
            }
        } else {
            self.chartStyle = chartStyle
        }
        
        
        self.chartStyle.backgroundColor = (canvasBackgroundColor != nil) ? canvasBackgroundColor! : self.chartStyle.backgroundColor
        self.chartStyle.backgroundGradient = (chartBackgroundGradient != nil) ? chartBackgroundGradient! : self.chartStyle.backgroundGradient
        self.chartStyle.lineGradient = (lineGradient != nil) ? lineGradient! : self.chartStyle.lineGradient
        self.chartStyle.textColor = (titleColor != nil) ? titleColor! : self.chartStyle.textColor
        self.chartStyle.legendTextColor = (subtitleColor != nil) ? subtitleColor! : self.chartStyle.legendTextColor
        self.chartStyle.numbersColor = (numberColor != nil) ? numberColor! : self.chartStyle.numbersColor
        
        self.shouldShowHighAndLowValues = shouldShowHighAndLowValues
    }
    
    
    public var body: some View {
        LineChartView(data: self.data,
                      headlinePrice: self.headlinePrice,
                      title: self.title,
                      legend: self.subtitle,
                      style: self.chartStyle,
                      valueSpecifier: self.floatingPointNumberFormat,
                      cursorColor: self.cursorColor,
                      curvedLines: self.curvedLines,
                      displayChartStats: self.displayChartStats,
                      minWidth: self.minWidth,
                      minHeight: self.minHeight,
                      maxWidth: self.maxWidth,
                      maxHeight: maxHeight,
                      titleFont: self.titleFont,
                      subtitleFont: self.subtitleFont,
                      priceFont: self.priceFont,
                      fullScreen: self.fullScreen,
                      showHighAndLowValues: self.shouldShowHighAndLowValues,
                      timePeriodText: self.timePeriodText)
    }
}


public enum LineChartStyle {
    case primary
    case secondary
    case tertiary
    case dark
//    case custom(ChartStyle)
}

public enum BarChartStyle {
    case barChartStyleOrangeLight
    case barChartStyleOrangeDark
    case barChartStyleNeonBlueLight
    case barChartStyleNeonBlueDark
    case barChartMidnightGreenDark
    case barChartMidnightGreenLight
    case custom(ChartStyle)
}

public enum PieChartStyle {
    case pieChartStyleOne
    case custom(ChartStyle)
}


public var myStyle: ChartStyle = ChartStyle(
    backgroundColor: Color.white,
    accentColor: Color.orange,
    secondGradientColor: Color.red,
    textColor: Color.black,
    legendTextColor: Color.gray,
    dropShadowColor: Color.gray)

