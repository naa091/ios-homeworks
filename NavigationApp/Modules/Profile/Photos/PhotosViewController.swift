import UIKit
import iOSIntPackage

extension QualityOfService {
    var qosLabel: String {
        switch self {
        case .userInteractive: return "userInteractive"
        case .userInitiated:   return "userInitiated"
        case .utility:         return "utility"
        case .background:      return "background"
        case .default:         return "default"
        @unknown default:      return "unknown"
        }
    }
}

final class PhotosViewController: UIViewController {
    // MARK: - Properties

    private var images: [UIImage] = []

    private let userImages: [UIImage] = {
        Images.allCases.compactMap {
            $0.image(name: $0).downsampled(maxDimension: 400)
        }
    }()
    
    private let imageProcessor = ImageProcessor()
    
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
        
        // Обработка изображений
        applyColorFiltersAndMeasurePerformance()
    }
}

// MARK: - Private methods

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
    
    private func applyColorFiltersAndMeasurePerformance() {
        let filters: [ColorFilter] = [
            .sepia(intensity: 0.8),
            .monochrome(color: CIColor(red: 0.7, green: 0.7, blue: 0.7), intensity: 1.0),
            .gaussianBlur(radius: 2.0)
        ]
        
        let qosLevels: [QualityOfService] = [
            .userInitiated,
            .utility,
            .background,
            .userInteractive,
            .default
        ]
        
        for (index, qos) in qosLevels.enumerated() {
            let selectedFilter = filters[index % filters.count]
            let inputImages = userImages.shuffled()
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            processImages(
                sourceImages: inputImages,
                filter: selectedFilter,
                qos: qos
            ) { [weak self] processedImages in
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("⏱️ Simulated Queue Label: imageprocessing.\(qos.qosLabel) → \(String(format: "%.3f", timeElapsed)) sec")
                
                self?.images = processedImages
                self?.collectionView.reloadData()
            }
        }
    }


    func processImages(
        sourceImages: [UIImage],
        filter: ColorFilter,
        qos: QualityOfService,
        completion: @escaping ([UIImage]) -> Void
    ) {
        let imageProcessor = ImageProcessor()

        imageProcessor.processImagesOnThread(
            sourceImages: sourceImages,
            filter: filter,
            qos: qos
        ) { cgImages in
            let uiImages = cgImages.compactMap { cgImage in
                cgImage.map { UIImage(cgImage: $0) }
            }

            // Возвращаем результат в главном потоке
            DispatchQueue.main.async {
                completion(uiImages)
            }
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

