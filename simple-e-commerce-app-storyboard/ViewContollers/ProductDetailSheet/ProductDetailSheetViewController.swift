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
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
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
        configureButton(minusButton, systemName: "minus")
        configureButton(plusButton, systemName: "plus")
        
        bind()

        viewModel.initData()
    }
    
    private func configureButton(_ button: UIButton, systemName: String) {
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .default)
        config.image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        button.configuration = config
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
        
        viewModel
            .$quantity
            .map(String.init)
            .assign(to: \.text, on: quantityLabel)
            .store(in: &cancellables)
        
        viewModel
            .$quantity
            .map { $0 > 1 }
            .assign(to: \.isEnabled, on: minusButton)
            .store(in: &cancellables)

        viewModel
            .$quantity
            .combineLatest(viewModel.$activeVariant)
            .map { $0 < $1.quantity }
            .assign(to: \.isEnabled, on: plusButton)
            .store(in: &cancellables)
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
        viewModel.setQuantity(isAdding: false)
    }
    
    @IBAction func onPlusButtonClicked(_ sender: Any) {
        viewModel.setQuantity()
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
