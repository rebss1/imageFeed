import Foundation
import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    var imageUrl: URL?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
            let share = UIActivityViewController(
                activityItems: [imageView.image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBlockingProgressHUD.animate()
        imageView.kf.setImage(with: imageUrl) {
            [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let imageResult):
                self?.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                let alert = UIAlertController(title: "OOOPS!",
                                              message: "Something went wrong with picture(",
                                              preferredStyle: .alert)
                let button = UIAlertAction(title: "Ok",
                                           style: .cancel) { _ in
                    alert.dismiss(animated: true)
                    self?.dismiss(animated: true)
                }
                alert.addAction(button)
                self?.present(alert, animated: true)
            }
        }
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
