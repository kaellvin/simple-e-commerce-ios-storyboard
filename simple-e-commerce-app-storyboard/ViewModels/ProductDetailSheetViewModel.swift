//
//  ProductDetailSheetViewModel.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 08/01/2026.
//

import Foundation

@MainActor
class ProductDetailSheetViewModel {
    private let productRepository: ProductRepository
    private let productDetail: ProductDetail
    
    init(productRepository: ProductRepository, productDetail: ProductDetail) {
        self.productRepository = productRepository
        self.productDetail = productDetail
    }
    
    @Published private(set) var activeVariant: ProductVariant = ProductVariant.empty
    var pvOptionList: [PVOption] = []
    @Published private(set) var quantity = 1
    @Published private(set) var mainImageUrl = ""
    
    
    func initData() {
        let defaultVariant = productDetail.productVariants.first(where: { $0.id == productDetail.defaultVariantId })!
        let pvOptionList = initPvOptionList(productDetail: productDetail, defaultVariant: defaultVariant)
        
        let optionValueImage = getMatchedOptionValueImage(productDetail: productDetail,pv: defaultVariant)
        
        activeVariant = defaultVariant
        self.pvOptionList = pvOptionList
        mainImageUrl = optionValueImage.url
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
    
    func setQuantity(isAdding: Bool = true){
        if isAdding {
            quantity = quantity < activeVariant.quantity ? quantity + 1 : quantity
        }else{
            quantity -= 1
        }
    }
    
    func getMatchedOptionValueImage(productDetail: ProductDetail, pv: ProductVariant) -> OptionValueImage {
        let cachedProductOptions = productDetail.productOptions.sorted { a, b in
            a.position < b.position
        }
        let optionValueIdList = pv.variantOptions
            .filter { $0.optionValue.option.id == cachedProductOptions[0].optionId }
            .map { $0.optionValueId }
        
        return productDetail.optionValueImages.first { optionValueIdList.contains($0.optionValueId) }!
    }
}
