import UIKit

class EffectsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    let filters: [Filter]
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableIdentifier = "effectsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! EffectsCollectionViewCell
        cell.previewImageView.image = image
        return cell
    }
}
