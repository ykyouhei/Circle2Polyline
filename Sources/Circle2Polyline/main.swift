import Utility
import Basic

func main() {
    // CommandLine.argumentsでコマンドラインから引数を受け取れます
    // arguments[0]にはコマンド名が入ってくるので除いておきます。
    let arguments = Array(CommandLine.arguments.dropFirst())
    
    // コマンドオプションの定義
    let parser = ArgumentParser(
        usage: "-c [coordinate] -r [radius] -v [numberOfVertex]",
        overview: "中心座標と半径を指定して円を表すPolylineを生成します"
    )
    
    let coordinate = parser.add(
        option: "--coordinate",
        shortName: "-c",
        kind: String.self,
        usage: "円の中心地点の緯度経度 e.g: 35.6221790,139.7187892"
    )
    
    let radius = parser.add(
        option: "--radius",
        shortName: "-r",
        kind: Int.self,
        usage: "円の半径(km)"
    )
    
    let vertex = parser.add(
        option: "--vertex",
        shortName: "-v",
        kind: Int.self,
        usage: "optional(default: 360): 円を描画する際の頂点数"
    )
    
    do {
        let result = try parser.parse(arguments)
        
        guard
            let c = result.get(coordinate)?.split(separator: ","),
            let lat = c.first.flatMap(String.init).flatMap(Double.init),
            let lng = c.last.flatMap(String.init).flatMap(Double.init) else {
                throw OptionArgumentParseError(coordinate)
        }
        
        guard let r = result.get(radius) else {
            throw OptionArgumentParseError(radius)
        }
        
        let numberOfVertex = result.get(vertex) ?? 360
        let circle = Circle(lat: lat, lng: lng, radius: r)
        
        print(circle.generatePolyline(numberOfVertex: numberOfVertex))
    } catch let e {
        TerminalController(stream: stderrStream as! LocalFileOutputByteStream)?.write("\(e)", inColor: .red, bold: false)
        parser.printUsage(on: stderrStream)
    }
}

main()
