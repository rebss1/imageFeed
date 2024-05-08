import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: ImagesListCell) 
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImageListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.didTapLikeButton(self)
    }
    
    func setLike(_ isLiked: Bool) {
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "redLike")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "greyLike")
        }
    }
    
    func configCell(_ url: URL?, _ date: String, _ isLiked: Bool) {
        cellImage.kf.indicatorType = .activity
        let placeholder = UIImage(named: "placeholderImage")
        guard let url = url else { return }
        cellImage.kf.setImage(with: url,
                              placeholder: placeholder)
        dateLabel.text = date
        setLike(isLiked)
    }
}
