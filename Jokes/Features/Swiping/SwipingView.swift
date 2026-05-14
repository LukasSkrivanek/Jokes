import SwiftUI

struct SwipingView: View {
    let dataProvider = JokesDataProvider()

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    if let jokes = dataProvider.sections.first?.jokes, !jokes.isEmpty {
                        ZStack {
                            ForEach(jokes, id: \.self) { joke in
                                if let image = joke.image {
                                    SwipingCard(
                                        configuration: SwipingCard.Configuration(
                                            image: Image(uiImage: image),
                                            title: joke.text,
                                            description: dataProvider.sections.first?.title ?? ""
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
        .background(.bg)
        .navigationTitle("Swiping")
    }
}
