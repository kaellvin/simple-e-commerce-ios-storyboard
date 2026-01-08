//
//  ProductDetailViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import Foundation

@MainActor
class ProductDetailViewModel {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    @Published private(set) var productDetail: ProductDetail?
    var activeVariant: ProductVariant = ProductVariant.empty
    var pvOptionList: [PVOption] = []
    var quantity = 1
    var mainImageUrl = ""
    var selectedOptionGroupIdx =  -1
    var isAddToOptionExpanded = false
    var error:Error? = nil
    @Published private(set) var status: LoadingStatus = LoadingStatus.idle
    var event: ProductDetailEvent?
    
    var currentPrice: Double {
        let price = Double(activeVariant.price) ?? 0.0
        return price * Double(quantity)
    }
    
    var stock: Int {
        return activeVariant.quantity
    }
    
    func loadData(productId: String) async {
        status = LoadingStatus.loading
        do {
            productDetail = try await productRepository.getProduct(productId: productId)
            
            if let productDetail {
                let defaultVariant = productDetail.productVariants.first(where: { $0.id == productDetail.defaultVariantId })!
                let pvOptionList = initPvOptionList(productDetail: productDetail, defaultVariant: defaultVariant)
                
                let optionValueImage = getMatchedOptionValueImage(productDetail: productDetail,pv: defaultVariant)
                
                activeVariant = defaultVariant
                self.pvOptionList = pvOptionList
                mainImageUrl = optionValueImage.url
                
            }
            status = LoadingStatus.success
        } catch {
            status = LoadingStatus.failure(error.localizedDescription)
        }
    }
    
    func initPvOptionList(productDetail: ProductDetail, defaultVariant: ProductVariant) -> [PVOption] {
        
        var pvOptionInitList: [PVOption] = []
        
        for pv in productDetail.productVariants {
            for item in pv.variantOptions {
                
                let id = item.optionValue.id
                let name = item.optionValue.name
                let position = item.optionValue.position
                let option = item.optionValue.option
                
                if let matchedIdx = pvOptionInitList.firstIndex(where: { $0.name == option.name }) {
                    var selectablePVOptionValues = pvOptionInitList[matchedIdx].values
                    if(!selectablePVOptionValues.contains { $0.optionValue.name == name }){
                        selectablePVOptionValues.append(
                            SelectablePVOptionValue(
                                imageUrl: "",
                                optionValue: PVOptionValue(id: id, name: name, position: position),
                                isSelected: false,
                                isWithinSelection: false
                            )
                        )
                        pvOptionInitList[matchedIdx].values = selectablePVOptionValues
                    }
                    
                }else {
                    let newPVOption = PVOption(
                        id: option.id,
                        name: option.name,
                        publicLabel: option.publicLabel,
                        values: [
                            SelectablePVOptionValue(
                                imageUrl: "",
                                optionValue: PVOptionValue(id: id, name: name, position: position),
                                isSelected: false,
                                isWithinSelection: false
                            )
                        ]
                    )
                    pvOptionInitList.append(newPVOption)
                }
                
                
                
            }
        }
        
        //sort option based on configured order
        let poMap = Dictionary(uniqueKeysWithValues: productDetail.productOptions.map { ($0.optionId, $0.position) })
        
        pvOptionInitList = pvOptionInitList.map({ pvOption in
            var newPvOption = pvOption
            newPvOption.values = pvOption.values.sorted(by: { a, b in
                a.optionValue.position < b.optionValue.position
            })
            return newPvOption
        })
        .sorted(by: { a, b in
            poMap[a.id]! < poMap[b.id]!
        })
        
        //highlight default option & load option image
        for vo in defaultVariant.variantOptions {
            pvOptionInitList = pvOptionInitList.enumerated().map { opIdx, op in
                var newOp = op
                newOp.values = op.values.enumerated().map({ idx, item in
                    var imageUrl = ""
                    if opIdx == 0 {
                        let matchedOpValImg = productDetail.optionValueImages.first(where: { $0.optionValueId == item.optionValue.id && $0.productId == productDetail.id  })!
                        imageUrl = matchedOpValImg.url
                    }
                    
                    var newItem = item
                    newItem.imageUrl = imageUrl
                    newItem.isSelected = (item.optionValue.id == vo.optionValueId) ? true : item.isSelected
                    return newItem
                })
                
                return newOp
            }
        }
        
        //using default variant option highlighted in first row to determine the selectability of options underneath
        let topSelectablePVOptionValue = pvOptionInitList[0].values.first { $0.isSelected }!
        let productVariantIds = productDetail.productVariants
            .flatMap { $0.variantOptions }
            .filter { topSelectablePVOptionValue.optionValue.id == $0.optionValueId}
            .map { $0.productVariantId }
        let optionValueIds = productDetail.productVariants
            .flatMap { $0.variantOptions }
            .filter { productVariantIds.contains($0.productVariantId) }
            .map { $0.optionValueId }
        
        pvOptionInitList = pvOptionInitList.enumerated().map({idx, pvOption in
            var newOption = pvOption
            newOption.values = pvOption.values.map({ value in
                var newValue = value
                newValue.isWithinSelection = optionValueIds.contains(value.optionValue.id) || idx == 0
                return newValue
            })
            return newOption
        })
        
        return pvOptionInitList
    }
    
    func onOptionSelected(chipGroupIdx: Int, chipTag: ChipTag){
        
        if let productDetail {
            if chipGroupIdx == 0 {
                //find all option combinations that contain selected option
                let productVariantIds = productDetail.productVariants
                    .flatMap { $0.variantOptions }
                    .filter {chipTag.optionValue.id == $0.optionValueId}
                    .map {$0.productVariantId}
                
                let optionValueIds = productDetail.productVariants
                    .flatMap { $0.variantOptions }
                    .filter { productVariantIds.contains($0.productVariantId) }
                    .map { $0.optionValueId }
                
                //find first product variant that contain selected option
                let matchedProductVariant = productDetail.productVariants.first { productVariant in
                    productVariant.variantOptions.contains{$0.optionValueId == chipTag.optionValue.id}
                }!
                
                let pvOptionValueIds = matchedProductVariant.variantOptions.map { $0.optionValueId }
            
                let newPvOptionList = pvOptionList.map {op in
                    var newOp = op
                    newOp.values = op.values.map {value in
                        var newValue = value
                        newValue.isSelected = pvOptionValueIds.contains(value.optionValue.id)
                        newValue.isWithinSelection = optionValueIds.contains(value.optionValue.id) || op.id == chipTag.pvOptionId
                        return newValue
                    }
                    return newOp
                    
                }
                let optionValueImage = getMatchedOptionValueImage(productDetail: productDetail, pv: matchedProductVariant)
                
                activeVariant = matchedProductVariant
                pvOptionList = newPvOptionList
                quantity = 1
                mainImageUrl = optionValueImage.url
                selectedOptionGroupIdx = chipGroupIdx
                
            }else {
                //update only option value within same type
                let newPvOptionList = pvOptionList.map {op in
                    var newOp = op
                    newOp.values = op.values.map {value in
                        var newValue = value
                        newValue.isSelected = op.id == chipTag.pvOptionId ? value.optionValue.name == chipTag.optionValue.name : value.isSelected
                        return newValue
                    }
                    return newOp
                }
                
                //extract product variant that matches all selected options
                let selectedOptionValueIds = newPvOptionList.flatMap { pvOption in
                    pvOption.values
                        .filter { $0.isSelected }
                        .map {$0.optionValue.id}
                }
                
                let newSelectedProductVariant = productDetail.productVariants.first{ productVariant in
                    productVariant.variantOptions.allSatisfy { selectedOptionValueIds.contains($0.optionValueId) }
                }!
                
                let optionValueImage = getMatchedOptionValueImage(productDetail: productDetail, pv: newSelectedProductVariant)
                
                activeVariant = newSelectedProductVariant
                pvOptionList = newPvOptionList
                quantity = 1
                mainImageUrl = optionValueImage.url
                selectedOptionGroupIdx = chipGroupIdx
            }
        }
        
    }
    
    func setQuantity(isAdding: Bool = true){
        if isAdding {
            quantity = quantity < activeVariant.quantity ? quantity + 1 : quantity
        }else{
            quantity -= 1
        }
    }
    
//    func validateBeforeAddingCartItem(cart: Cart?) {
//        var newQuantity = quantity
//        let productVariantId = activeVariant.id
//        if let cart {
//            let cartItemAndSelection = cart.cartItemAndSelections.first(where: { $0.cartItem.productVariantId == activeVariant.id })
//            
//            if let cartItemAndSelection {
//                newQuantity += cartItemAndSelection.cartItem.quantity
//            }
//            
//            let activeVariantQuantity = activeVariant.quantity
//            
//            if newQuantity > activeVariantQuantity {
//                event = .quantityExceeded(stock: activeVariantQuantity)
//            }else {
//                let cartItemQuantityUpdate = CartItemQuantityUpdate(quantity: newQuantity, cartId: cart.id)
//                event = .addToExistingCart(productVariantId: productVariantId, body: cartItemQuantityUpdate)
//            }
//            
//        }else {
//            let cartItemAdd = CartItemAdd(quantity: quantity, productVariantId: productVariantId)
//            event = .addCartItem(body: cartItemAdd)
//        }
//    }
  
    func getMatchedOptionValueImage(productDetail: ProductDetail, pv: ProductVariant) -> OptionValueImage {
        let cachedProductOptions = productDetail.productOptions.sorted { a, b in
            a.position < b.position
        }
        let optionValueIdList = pv.variantOptions
            .filter { $0.optionValue.option.id == cachedProductOptions[0].optionId }
            .map { $0.optionValueId }
        
        return productDetail.optionValueImages.first { optionValueIdList.contains($0.optionValueId) }!
    }

    enum ProductDetailEvent: Equatable {
//        case quantityExceeded(stock: Int)
//        case addCartItem(body: CartItemAdd)
//        case addToExistingCart(productVariantId: String, body: CartItemQuantityUpdate)
    }

    
}
