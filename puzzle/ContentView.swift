

import SwiftUI
import SwiftImage

enum Consts {
    static let columns = 3
    static let rows = 3
    static let columnsSpacing: CGFloat = 4
    static let rowsSpacing: CGFloat = 4
}

struct Coord {
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    var x: Int
    var y: Int
}

struct ContentView: View {
    @State private var showImage = false


    @State
    var data = Self.initialData

    let imageParts: [[UIImage]] = {
        let pic = SwiftImage.Image<RGBA<UInt8>>(named: "pilestone")!
        var img: [[UIImage]] = []
        for x in 0..<Consts.columns {
            img.append([])
            for y in 0..<Consts.rows {
                let widthPart = pic.width / Consts.columns
                let heightPart = pic.height / Consts.rows
                let slice = SwiftImage.Image<RGBA<UInt8>>(
                    pic[(widthPart * x)..<(widthPart * (x + 1)),
                        (heightPart * y)..<(heightPart * (y + 1))]
                ).uiImage
                img[x].append(slice)
            }
        }
        return img
    }()

    @ViewBuilder
    func cell(_ dataCoord: Coord) -> some View {
        if let imageCoord = getData(at: dataCoord) {
            Image(uiImage: imageParts[imageCoord.x][imageCoord.y])
                .resizable()
                .onTapGesture {
                    let freeCoord = freeCoord
                    switch (abs(freeCoord.x - dataCoord.x),
                            abs(freeCoord.y - dataCoord.y)) {
                    case (1, 0), (0, 1):
                        withAnimation {
                            swap(dataCoord, freeCoord)
                        }

                    default: break
                    }
                }
        } else {
            Color.clear
        }
    }

    @ViewBuilder
    var body: some View {
        
        //-----------------------
//        GeometryReader { gr in
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.pink)
//                .overlay(
//                    VStack {
//                        Text("X: \(Int(gr.frame(in: .global).origin.x))")
//                        Text("Y: \(Int(gr.frame(in: .global).origin.y))")
//                })
//        }.frame(width:  200 ,height: 40)
        //--------------------------
        
        NavigationView {
            
            VStack(spacing: Consts.rowsSpacing) {
                ForEach(0..<Consts.rows) { y in
                    HStack(spacing: Consts.columnsSpacing) {
                        ForEach(0..<Consts.columns) { x in
                            cell(.init(x, y)).frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }.toolbar {

            }.frame(width: 320 , height: 350)
           .navigationTitle(Text("Puzzle"))
        }
        
    
          VStack(){ if showImage {
               Image(systemName: "pilestone")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 75, height: 75)
           Image("pilestone").resizable()
                   .frame(width: 180 , height: 180)}
        }

               
       HStack{      Button(action: { showImage.toggle() }) {
            Image(systemName: "lightbulb.fill")
                .resizable()

                .frame(width: 20 , height: 30)
                .foregroundColor(Color(red: 0.411, green: 0.861, blue: 0.932))
               
        }
 
    Button {
        data = Self.initialData

    } label: {
        Label("", systemImage: "return.left")
            .foregroundColor(Color(red: 0.411, green: 0.861, blue: 0.932))
            
    }
    Button {
        data = shuffledData

    } label: {
        Label("", systemImage: "shuffle")
            .foregroundColor(Color(red: 0.411, green: 0.861, blue: 0.932))
    }}
   
        
        //end
        
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

private extension ContentView {
    static var initialData: [[Coord?]] {
        var dat = [[Coord?]]()
        for x in 0..<Consts.columns {
            dat.append(.init())
            for y in 0..<Consts.rows {
                dat[x].append(.init(x, y))
            }
        }
        dat[dat.count - 1][dat.last!.count - 1] = nil
        
        return dat
    }

    var shuffledData: [[Coord?]] {
        data.reduce([Coord?](), +).shuffled().chunked(into: Consts.rows)
    }

    func getData(at coord: Coord) -> Coord? {
        guard 0..<Consts.rows ~= coord.y, 0..<Consts.columns ~= coord.x else { return nil }
        return data[coord.x][coord.y]
    }

    func updateData(at coord: Coord, _ newValue: Coord?) {
        guard 0..<Consts.rows ~= coord.y, 0..<Consts.columns ~= coord.x else { return }
        data[coord.x][coord.y] = newValue
    }

    func swap(_ lhs: Coord, _ rhs: Coord) {
        let val = getData(at: lhs)
        data[lhs.x][lhs.y] = getData(at: rhs)
        data[rhs.x][rhs.y] = val
    }

    var freeCoord: Coord {
        for x in 0..<Consts.columns {
            for y in 0..<Consts.rows {
                if data[x][y] == nil {
                    return .init(x, y)
                }
            }
        }
        fatalError()
    }
}
