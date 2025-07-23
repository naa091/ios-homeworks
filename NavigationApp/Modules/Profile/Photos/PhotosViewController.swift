import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    // MARK: - Properties
    
    private let facade = ImagePublisherFacade()
    private let timeInterval = 0.5
    private let repeatCount = 16
    
    private var images: [UIImage] = []
    
    private let userImages: [UIImage] = {
        Images.allCases.compactMap {
            $0.image(name: $0).downsampled(maxDimension: 400)
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 8
        let columns: CGFloat = 3
        let sideInsets: CGFloat = 16
        let totalSpacing = (columns - 1) * spacing + sideInsets
        
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / columns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        collection.dataSource = self
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collection
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        
        facade.subscribe(self)
        facade.addImagesWithTimer(time: timeInterval, repeat: repeatCount, userImages: userImages)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        facade.removeSubscription(for: self)
    }
}

//MARK: - Private methods
private extension PhotosViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - ImageLibrarySubscriber

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        self.images = images
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        else {
            fatalError("Unable to dequeue ImageCell")
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
}
