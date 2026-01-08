//
//  ProductDetailSheetViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 08/01/2026.
//

import UIKit
import Combine

class ProductDetailSheetViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    private var viewModel: ProductDetailSheetViewModel
    private var cancellables = Set<AnyCancellable>()
    
    required init?(coder: NSCoder, productDetail: ProductDetail) {
        viewModel = ProductDetailSheetViewModel(productRepository: DefaultProductRepository(), productDetail: productDetail)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:productDetail:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    
        viewModel.initData()
    }
    

    
    private func bind() {
        viewModel
            .$mainImageUrl
            .sink { [weak self] mainImageUrl in
                guard let self else { return }
                Task {
                    let image = await ImageLoader.shared.loadImage(from: mainImageUrl)
                    await MainActor.run {
                        self.mainImageView.image = image
                    }
                }
            }.store(in: &cancellables)
        
        viewModel
            .$activeVariant
            .combineLatest(viewModel.$quantity)
            .sink { [weak self] activeVariant, quantity in
                guard let self else { return }
                        let price = Double(activeVariant.price) ?? 0.0
                        let currentPrice = price * Double(quantity)
                
                self.priceLabel.text = "Price: \(Int(currentPrice).formatted(.currency(code: "MYR")))"
                self.stockLabel.text = "Stock: \(activeVariant.quantity)"
            }.store(in: &cancellables)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
