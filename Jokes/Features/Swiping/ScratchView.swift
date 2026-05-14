import SwiftUI

struct ScratchView: View {
    let image: Image
    let text: String

    @State private var currentLine = Line()
    @State private var lines = [Line]()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                image
                    .resizableBordered(cornerRadius: UIConstants.cornerRadius)
                    .scaledToFit()

                RoundedRectangle(cornerRadius: UIConstants.cornerRadius)
                    .fill(.bg)
                    .overlay {
                        Text(text)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .gesture(dragGesture)
                    .frame(width: geometry.size.width, height: geometry.size.height / 1.65)
                    .mask {
                        Canvas { context, _ in
                            for line in lines {
                                var path = Path()
                                path.addLines(line.points)
                                context.stroke(
                                    path,
                                    with: .color(.white),
                                    style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round)
                                )
                            }
                        }
                    }
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                currentLine.points.append(value.location)
                lines.append(currentLine)
            }
    }
}

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 50.0
}
