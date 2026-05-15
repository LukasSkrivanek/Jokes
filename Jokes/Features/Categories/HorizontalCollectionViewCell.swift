import UIKit
import SwiftUI

final class HorizontalScrollingCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private var jokes: [Joke] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with jokes: [Joke]) {
        self.jokes = jokes
        collectionView.reloadData()
    }
}

// MARK: - Setup UI
private extension HorizontalScrollingCollectionViewCell {
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalScrollingCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        jokes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let joke = jokes[indexPath.item]
        cell.contentConfiguration = UIHostingConfiguration {
            Text(joke.text)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg)
                .cornerRadius(UIConstants.cornerRadius)
                .bordered(cornerRadius: UIConstants.cornerRadius)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HorizontalScrollingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height)
    }
}
