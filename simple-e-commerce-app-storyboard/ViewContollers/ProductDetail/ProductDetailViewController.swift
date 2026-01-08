//
//  ProductDetailViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import UIKit
import Combine

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var productDetailContentView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    private var viewModel = ProductDetailViewModel(productRepository: DefaultProductRepository())
    private var cancellables = Set<AnyCancellable>()
    
    var id: String
    
    required init?(coder: NSCoder, id: String) {
        self.id = id
        super.init(coder: coder)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:id:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        productDetailContentView.isHidden = true
        bind()
        
        collectionView.dataSource = self
        //        collectionView.delegate = self
        
        setupNavigationButtons()
        
        Task {
            await viewModel.loadData(productId: id)
        }
    }
    
    private func bind() {
        viewModel
            .$productDetail
            .combineLatest(viewModel.$status)
            .sink { [weak self] productDetail, status in
                guard let self else { return }
               
                switch status {
                case .idle, .loading:
                    indicatorView.startAnimating()
                case .success:
                    indicatorView.stopAnimating()
                    if let productDetail {
                        self.collectionView.reloadData()
                        
                        self.productName.text = productDetail.name
                        self.productDescription.text = productDetail.description
                        
                        productDetailContentView.isHidden = false
                    }else {   
                        errorLabel.text = "No matching product found."
                        errorLabel.isHidden = false
                    }
                       
                case .failure(_):
                    indicatorView.stopAnimating()
                    errorLabel.text = "Something wrong. Please try again later."
                    errorLabel.isHidden = false
                }
                
                
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationButtons() {
        let backButtonAction = UIAction { [unowned self] action in
            self.navigationController?.popViewController(animated: true)
        }
        
        let cartButtonAction = UIAction { action in
            //TODO:
        }
        
        let backButton = createButtonItem(systemName: "chevron.left", uiAction: backButtonAction)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let cartButton = createButtonItem(systemName: "cart", uiAction: cartButtonAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        //navigationItem.hidesBackButton = true
    }
    
    private func createButtonItem(systemName: String, uiAction : UIAction) -> UIButton {
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .default)
        config.image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        
        return UIButton(configuration: config,primaryAction: uiAction)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        layout.itemSize = collectionView.bounds.size
    }
    
}


extension ProductDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetail?.productImageUrls.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productDetail = viewModel.productDetail!
        let imageURL = productDetail.productImageUrls[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailCell
        cell.configure(with: imageURL)
        return cell
    }
}

//extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        CGSize(
//            width: collectionView.bounds.width,
//            height: collectionView.bounds.height
//        )
//    }
//
//}
