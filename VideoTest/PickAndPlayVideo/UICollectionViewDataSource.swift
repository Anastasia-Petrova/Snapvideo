import UIKit

class EffectsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableIdentifier = "effectsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! EffectsCollectionViewCell
        cell.previewImageView.image = image
        
        return cell
    }
    

}
