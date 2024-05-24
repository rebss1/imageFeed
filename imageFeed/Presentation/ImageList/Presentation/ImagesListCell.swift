import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: ImagesListCell) 
}

public final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImageListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.didTapLikeButton(self)
    }
    
    func setLike(_ isLiked: Bool) {
        if isLiked {
            likeButton.setBackgroundImage(UIImage(named: "redLike"),
                                          for: .normal)
        } else {
            likeButton.setBackgroundImage(UIImage(named: "greyLike"),
                                          for: .normal)
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
