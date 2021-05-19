# iLineChart
Quickly implement & easily customize great looking line charts.


## Get Started
```swift
import SwiftUI
import iLineChart

struct ContentView: View {
  var body: some View {
      iLineChart(data: [8,32,11,23,40,28,15,20,30,25])
  }
}
```
<img src="https://iswiftui.com/assets/img/demo1.gif" width="300">

## Examples 
### Example 1
Enable chart statistics to make your chart & its data interactive.
Add a title to give your chart some context.
```swift
import SwiftUI
import iLineChart

struct ContentView: View {
    var body: some View {
        iLineChart(
            data: [8,32,11,23,40,28,15,20,30,25],
            title: "My Graph",
            displayChartStats: true
        )
    }
}
```
<img src="https://iswiftui.com/assets/img/demo2.gif" width="300">
<h3> Example 2</h2>
Utalize the built in ExampleData to test your chart with sophisticated data.
Set curvedLines to false to give your stocks graph a more realistic feel.
Choose style: .tertiary for a minimalist chart aesthetic.

```swift
import SwiftUI
import iLineChart

struct ContentView: View {
    var data:[Double] = ExampleData.stockData

    var body: some View {
        iLineChart(
            data: data,
            title: "AAPL",
            subtitle: "Apple Computers",
            style: .tertiary,
            curvedLines: false,
            displayChartStats: true
        )
    }
}
```
<img src="https://iswiftui.com/assets/img/demo3.gif" width="300">

<h3> Example 3</h2>
Enable fullscreen to cover the safe areas with your background color.
Change the font to your company's brand.

```swift
import SwiftUI
import iLineChart

struct ContentView: View {
    var data:[Double] = ExampleData.stockData

    var body: some View {
        iLineChart(
            data: data,
            title: "My Dark Themed App",
            subtitle: "Sleek. Simple.",
            style: .dark,
            titleColor: Color.red,
            cursorColor: .black,
            titleFont: .system(size: 14, weight: .regular, design: .monospaced),
            subtitleFont: .system(size: 24, weight: .bold, design: .monospaced),
            fullScreen: true
        )
    }
}
```
<img src="https://iswiftui.com/assets/img/demo4.gif" width="300">


## Customize 
iLineChart supports a variety of custom parameters. All custom parameters are built into the struct initialization.

Parameter | Description
--- | ---
`title: String?  =  nil` | Add a title above your graph.
`subtitle: String?  =  nil` | Add a subtitle below your title and above your graph.
`style:  LineChartStyle  =  .primary` | LineChartStyle is an enum of different default style choices. You can choose between .primary, .secondary, .tertiary or .dark.
`lineGradient:  GradientColor?  =  nil` | Change the gradient of the graph line.
`chartBackgroundGradient:  GradientColor?  =  nil` | Change the gradient that lies below the chart line.
`canvasBackgroundColor: Color?  =  nil` | Change the canvas color that lies behind the entire View (including the header text).
`titleColor: Color?  =  nil` | Change the title color.
`subtitleColor: Color?  =  nil` | 	Change the subtitle color.
`numberColor: Color?  =  nil` | Change the color of the graph numbers.
`curvedLines: Bool  =  true` | Does your graph have curved or straight lines.
`cursorColor: Color  =  Color.NeonPink` | When a user clicks on the graph, this parameters controls their cursor color. Use the internal Color struct to quickly access good colors.
`displayChartStats:  Bool  =  false` | Display a line of text that reads the final data point, the current selected point (when applicable) and the percent change from the first data point.
`minWidth: CGFloat  =  0` | Minimum chart width.
`minHeight: CGFloat  =  0` | Minimum chart height.
`maxWidth: CGFloat  =  .infinity` | Maximum chart width.
`maxHeight: CGFloat  =  .infinity` | Maximum chart height.
`titleFont: Font  = .system(size: 30, weight: .regular, design: .rounded)` | Title font.
`subtitleFont: Font  = .system(size: 14, weight: .light, design: .rounded)` | Subtitle font.
`dataFont: Font  = .system(size: 16, weight: .bold, design: .monospace) ` | Data font.
`fullScreen: Bool  =  false` | Allow chart view to expand to the entire screen – including safe areas.
`floatingPointNumberFormat: String  =  "%.1f"` | A regular expression for how to format datapoints from the chart.
