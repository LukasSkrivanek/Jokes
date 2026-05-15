import SwiftUI

struct SwipingView: View {
    @StateObject private var store = SwipingStore()

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    if store.state.isLoading {
                        ProgressView()
                    } else if !store.state.sections.isEmpty {
                        ZStack {
                            ForEach(store.state.sections) { section in
                                if let joke = section.jokes.first {
                                    SwipingCard(
                                        configuration: SwipingCard.Configuration(
                                            title: section.title,
                                            description: joke.text
                                        ),
                                        onSwipe: { swipeState in
                                            if case .finished = swipeState {
                                                Task {
                                                    await store.send(.jokeRemoved(joke))
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.top, geometry.size.height / 20)
                        .frame(
                            width: geometry.size.width / 1.2,
                            height: (geometry.size.width / 1.2) * 1.5
                        )
                    } else {
                        Text("No jokes available")
                            .textStyle(textType: .baseText)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .task {
            await store.send(.load)
        }
        .background(.bg)
        .navigationTitle("Swiping")
    }
}
