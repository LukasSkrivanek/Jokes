import UIKit
import Combine
import SwiftUI

final class CategoriesViewController: UIViewController, EventEmitting {
    enum Event {
        case categorySelected(String)
    }

    private let eventSubject = PassthroughSubject<Event, Never>()
    var eventPublisher: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    private let store: CategoriesStore
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    typealias DataSource = UICollectionViewDiffableDataSource<JokeSection, Joke>
    typealias Snapshot = NSDiffableDataSourceSnapshot<JokeSection, Joke>

    private lazy var dataSource = makeDataSource()
    private var cancellables = Set<AnyCancellable>()

    init(store: CategoriesStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        setup()
        Task { await store.send(.load) }
    }
}

// MARK: - Setup
private extension CategoriesViewController {
    func setup() {
        setupCollectionView()
        setupActivityIndicator()
        observeData()
    }

    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = false

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .bg
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(HorizontalScrollingCollectionViewCell.self)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SectionHeader"
        )
        view.addSubview(collectionView)
    }

    func observeData() {
        store.$state
            .map(\.sections)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.applySnapshot(sections: sections)
            }
            .store(in: &cancellables)

        store.$state
            .map(\.isLoading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    func applySnapshot(sections: [JokeSection], animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.jokes, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, _: Joke) -> UICollectionViewCell? in
            guard let self else { return UICollectionViewCell() }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let cell: HorizontalScrollingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: section.jokes, onTap: { [weak self] in
                self?.eventSubject.send(.categorySelected(section.title.lowercased()))
            })
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionHeader",
                for: indexPath
            )
            let hostingController = UIHostingController(rootView: SectionHeaderView(title: section.title))
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            headerView.subviews.forEach { $0.removeFromSuperview() }
            headerView.addSubview(hostingController.view)
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: headerView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
            ])
            return headerView
        }

        return dataSource
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3.4)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {}
