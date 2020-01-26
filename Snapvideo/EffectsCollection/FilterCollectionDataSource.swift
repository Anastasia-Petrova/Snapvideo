import UIKit

class FilterCollectionDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    let filters: [AnyFilter]
    var filteredImages: [String: UIImage] = [:]
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    let context: CIContext
    
    init(collectionView: UICollectionView, filters: [AnyFilter], context: CIContext) {
        self.filters = filters
        self.collectionView = collectionView
        self.context = context
        super.init()
        collectionView.dataSource = self
        collectionView.register(
            EffectsCollectionViewCell.self,
            forCellWithReuseIdentifier: "effectsCollectionViewCell"
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableIdentifier = "effectsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! EffectsCollectionViewCell
        cell.filterName.text = filters[indexPath.row].name
        
        if let filteredImage = filteredImages[filters[indexPath.row].name] {
            cell.previewImageView.image = filteredImage
        } else {
            if let image = image {
                let filteredImage = filter(image: image, indexPath: indexPath)
                filteredImages[filters[indexPath.row].name] = filteredImage
                cell.previewImageView.image = filteredImage
            }
        }
        
        return cell
    }
    
    func filter(image: UIImage, indexPath: IndexPath) -> UIImage {
        var uiImage = image
        if let cgImage = image.cgImage {
            let ciImage = CIImage(cgImage: cgImage)
            let filteredCIImage = filters[indexPath.row].apply(ciImage)
            if let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
                uiImage = UIImage(cgImage: filteredCGImage)
            }
        }
        return uiImage
    }
}
