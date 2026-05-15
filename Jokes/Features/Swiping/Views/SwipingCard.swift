import SwiftUI

typealias Action<T> = (T) -> Void

struct SwipingCard: View {
    enum SwipeDirection {
        case left, right
    }

    enum SwipeState {
        case swiping(direction: SwipeDirection)
        case finished(direction: SwipeDirection)
        case canceled
    }

    struct Configuration: Equatable {
        let title: String
        let description: String
    }

    private let configuration: Configuration
    private let onSwipe: (SwipeState) -> Void
    @State private var offset: CGSize = .zero
    @State private var cardColor: Color = .bg

    init(configuration: Configuration, onSwipe: @escaping (SwipeState) -> Void) {
        self.configuration = configuration
        self.onSwipe = onSwipe
    }

    var body: some View {
        VStack {
            Spacer()
            ScratchView(text: configuration.description)
            Spacer()
            cardTitle
        }
        .frame(maxWidth: .infinity)
        .background(cardColor)
        .cornerRadius(UIConstants.cornerRadius)
        .offset(x: offset.width, y: offset.height * 0.5)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(dragGesture)
    }

    private var cardTitle: some View {
        Text(configuration.title)
            .textStyle(textType: .sectionTitle)
            .padding(10)
            .background(.black.opacity(0.5))
            .cornerRadius(UIConstants.cornerRadius)
            .padding(.bottom)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation { updateColor(for: offset) }
            }
            .onEnded { _ in
                withAnimation { finishSwipe(translation: offset) }
            }
    }
}

// MARK: - Swipe logic
private extension SwipingCard {
    func finishSwipe(translation: CGSize) {
        if (-500)...(-200) ~= translation.width {
            offset = CGSize(width: -500, height: 0)
            onSwipe(.finished(direction: .left))
        } else if 200...500 ~= translation.width {
            offset = CGSize(width: 500, height: 0)
            onSwipe(.finished(direction: .right))
        } else {
            offset = .zero
            cardColor = .bg
            onSwipe(.canceled)
        }
    }

    func updateColor(for translation: CGSize) {
        if translation.width < -60 {
            cardColor = .green.opacity(Double(abs(translation.width) / 500) + 0.6)
            onSwipe(.swiping(direction: .left))
        } else if translation.width > 60 {
            cardColor = .red.opacity(Double(translation.width / 500) + 0.6)
            onSwipe(.swiping(direction: .right))
        } else {
            cardColor = .bg
            onSwipe(.canceled)
        }
    }
}
