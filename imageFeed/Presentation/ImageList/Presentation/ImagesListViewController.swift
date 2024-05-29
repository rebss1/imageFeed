import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol? { get set }
    func getTable() -> UITableView
    func showAlert(data: AlertData)
    func updateTableViewAnimated(from: Int, to: Int)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageIdentifier = "ShowSingleImage"
    static let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            
    @IBOutlet private var tableView: UITableView!
    private var photosCount: Int = 0
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
    }
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
    }()
    
    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.presenter?.updateTableViewAnimated()
            }
    }

    func updateTableViewAnimated(from: Int, to: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (from..<to).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func getTable() -> UITableView { tableView }
    
    func showAlert(data: AlertData) {
        showAlert(alertData: data)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            guard let photo = presenter?.getPhotos()[indexPath.row] else { return }
            viewController.imageUrl = URL(string: photo.largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.getCellHeight(indexPath: indexPath) ?? 0
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotos().count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell,
              let photo = presenter?.getPhotos()[indexPath.row],
              let url = URL(string: photo.thumbImageURL) else {
            return UITableViewCell()
        }
        var dateText = ""
        if let date = presenter?.getPhotos()[indexPath.row].createdAt {
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
        let isTesting = ProcessInfo().arguments.contains("testMode")
        if !isTesting || (isTesting && indexPath.row == 1) {
            presenter?.fetchNextPhotos(indexPath: indexPath)
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLikeButton(_ cell: ImagesListCell) {
        presenter?.didTapLikeButton(cell: cell)
    }
}
