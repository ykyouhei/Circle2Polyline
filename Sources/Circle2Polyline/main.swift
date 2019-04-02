import Basic
import Foundation
import Utility

let stderrTc = TerminalController(stream: stderrStream as! LocalFileOutputByteStream)!
let stdoutTc = TerminalController(stream: stdoutStream as! LocalFileOutputByteStream)!

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

private func main() -> Int32 {
    do {
        let polyline: String

        if arguments.count == 0 {
            polyline = try polylineFromStdin()
        } else {
            polyline = try polylineFromArguments()
        }
        
        stdoutTc.write(polyline, inColor: .green, bold: true)
        return 0
    } catch let e {
        stderrTc.write("\(e)", inColor: .red, bold: false)
        parser.printUsage(on: stderrStream)
        return 1
    }
}

private func parseCoordinate(from string: String) -> (lat: Double, lng: Double)? {
    let c = string.split(separator: ",")
    
    guard
        let lat = c.first.flatMap(String.init).flatMap(Double.init),
        let lng = c.last.flatMap(String.init).flatMap(Double.init) else {
            return nil
    }
    
    return (lat: lat, lng: lng)
}

private func polylineFromStdin() throws -> String {
    let stdin = FileHandle.standardInput
    
    func readline() -> String? {
        return String(data: stdin.availableData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    stdoutTc.write("緯度経度(e.g: 35.6221790,139.7187892) -> ", inColor: .cyan, bold: false)
    guard let c = readline().flatMap(parseCoordinate(from:)) else {
        throw OptionArgumentParseError(coordinate)
    }
    
    stdoutTc.write("半径(km) -> ", inColor: .cyan, bold: false)
    guard let r = readline() else {
        throw OptionArgumentParseError(radius)
    }
    
    stdoutTc.write("頂点数 -> ", inColor: .cyan, bold: false)
    guard let v = readline() else {
        throw OptionArgumentParseError(radius)
    }
    

    return Circle(lat: c.lat, lng: c.lng, radius: Int(r)!).generatePolyline(numberOfVertex: Int(v)!)
}

private func polylineFromArguments() throws -> String {
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
    
    return Circle(lat: lat, lng: lng, radius: r).generatePolyline(numberOfVertex: numberOfVertex)
}

exit(main())
