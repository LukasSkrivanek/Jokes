import SwiftUI

struct SwipingView: View {
    @StateObject private var dataProvider = JokesDataProvider()

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    if dataProvider.isLoading {
                        ProgressView()
                    } else if !dataProvider.sections.isEmpty {
                        ZStack {
                            ForEach(dataProvider.sections) { section in
                                if let joke = section.jokes.first {
                                    SwipingCard(
                                        configuration: SwipingCard.Configuration(
                                            title: section.title,
                                            description: joke.text
                                        ),
                                        onSwipe: { _ in }
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
        .task { await dataProvider.load() }
        .background(.bg)
        .navigationTitle("Swiping")
    }
}
