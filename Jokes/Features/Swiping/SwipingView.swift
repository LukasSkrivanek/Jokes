import SwiftUI

struct SwipingView: View {
    
    @StateObject private var store: SwipingStore

    init(category: String? = nil) {
        _store = StateObject(wrappedValue: SwipingStore(category: category))
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    if store.state.isLoading {
                        ProgressView()
                    } else if !store.state.cards.isEmpty {
                        ZStack {
                            ForEach(store.state.cards) { card in
                                SwipingCard(
                                    configuration: SwipingCard.Configuration(
                                        title: card.categoryTitle,
                                        description: card.jokeText
                                    ),
                                    onSwipe: { swipeState in
                                        if case .finished = swipeState {
                                            Task {
                                                await store.send(.cardRemoved(card))
                                            }
                                        }
                                    }
                                )
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
