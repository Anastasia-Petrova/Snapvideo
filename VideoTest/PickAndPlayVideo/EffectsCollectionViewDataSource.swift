import UIKit

class EffectsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    let filters: [Filter]
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
    
    init(collectionView: UICollectionView, filters: [Filter]) {
        self.filters = filters
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.register(EffectsCollectionViewCell.self, forCellWithReuseIdentifier: "effectsCollectionViewCell")
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
//        if let img = image, let ciImage = img.ciImage {
//            let filteredCIImage = filters[indexPath.row].apply(image: ciImage)
//            let uiImage = UIImage(ciImage: filteredCIImage)
//            cell.previewImageView.image = uiImage
//        }
        cell.previewImageView.image = image
        cell.effectName.text = filters[indexPath.row].name
        return cell
    }
}
