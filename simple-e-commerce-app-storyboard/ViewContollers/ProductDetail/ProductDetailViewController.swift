//
//  ProductDetailViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import UIKit
import Combine

class ProductDetailViewController: UIViewController {
    
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
        bind()

        collectionView.dataSource = self
//        collectionView.delegate = self
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = collectionView.bounds.size
//        }
        
        //navigationItem.hidesBackButton = true
        
        
        Task {
            await viewModel.loadData(productId: id)
        }
    }
    
    private func bind() {
        viewModel
            .$productDetail
            .sink { [weak self] productDetail in
                guard let self else { return }
                guard let productDetail else { return }
                
                self.collectionView.reloadData()
                
                self.productName.text = productDetail.name
                self.productDescription.text = productDetail.description
            }
            .store(in: &cancellables)
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
