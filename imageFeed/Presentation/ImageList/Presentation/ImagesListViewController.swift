import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let showSingleImageIdentifier = "ShowSingleImage"
    static let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    
    let imagesListService = ImagesListService.shared
        
    @IBOutlet private var tableView: UITableView!
    private var photosCount: Int = 0
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }

    private func updateTableViewAnimated() {
        let oldCount = photosCount
        let newCount = imagesListService.photos.count
        photosCount = imagesListService.photos.count
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = imagesListService.photos[indexPath.row]
            viewController.imageUrl = URL(string: photo.thumbImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = imagesListService.photos[indexPath.row]
        let insets = ImagesListViewController.imageInsets
        let originalRatio =  photo.size.height / photo.size.width
        let imageViewWidth = tableView.bounds.width - insets.right - insets.left
        let cellHeight = imageViewWidth * originalRatio + insets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        let photo = imagesListService.photos[indexPath.row]
        let url = URL(string: photo.thumbImageURL)
        var dateText = ""
        if let date = imagesListService.photos[indexPath.row].createdAt {
            dateText = dateFormatter.string(from: date)
        }
        imageListCell.delegate = self
    
        imageListCell.configCell(url,
                                 dateText,
                                 photo.isLiked)
        return imageListCell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLikeButton(_ cell: ImagesListCell) {
        cell.likeButton.isEnabled = false
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id,
                                     isLike: !photo.isLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photo):
                    cell.setLike(photo.isLiked)
                case .failure:
                    let alert = UIAlertController(title: "OOOPS!",
                                                  message: "Something went wrong with like function(",
                                                  preferredStyle: .alert)
                    let button = UIAlertAction(title: "Ok",
                                               style: .cancel) { _ in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(button)
                    self.present(alert, animated: true)
                    break
                }
                cell.likeButton.isEnabled = true
            }
        }
    }
}
