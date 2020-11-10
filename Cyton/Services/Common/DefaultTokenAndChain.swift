//
//  DefaultTokenAndChain.swift
//  Cyton
//
//  Created by XiaoLu on 2018/12/6.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import RealmSwift

class DefaultTokenAndChain {
    func addDefaultTokenToWallet(wallet: WalletModel) {
        let walletRef = ThreadSafeReference(to: wallet)
        DispatchQueue.global().async {
            let realm = try! Realm()
            guard let walletModel = realm.resolve(walletRef) else {
                return
            }
//            self.bingShengToken(wallet: walletModel)
//            self.ethereum(wallet: walletModel)
//            self.testChain(chainHost: CITANetwork.defaultNode, wallet: walletModel)
            self.testChain(chainHost: "https://testnet.taidihub.com", wallet: walletModel)
        }
    }

    func ethereum(wallet: WalletModel) {
        let ethModel = TokenModel()
        ethModel.address = ""
        ethModel.decimals = NativeDecimals.nativeTokenDecimals
        ethModel.iconUrl = ""
        ethModel.isNativeToken = true
        ethModel.name = "ethereum"
        ethModel.symbol = "ETH"
        if let id = TokenModel.identifier(for: ethModel) {
            ethModel.identifier = id
        }

        let realm = try! Realm()
        try? realm.write {
            realm.add(ethModel, update: .modified)
            if !wallet.tokenModelList.contains(where: { $0 == ethModel }) {
                wallet.tokenModelList.append(ethModel)
                if !wallet.selectedTokenList.contains(where: { $0 == ethModel }) {
                    wallet.selectedTokenList.append(ethModel)
                }
            }
        }
    }
    
    func bingShengToken(wallet: WalletModel) {
        let bstModel = TokenModel()
        bstModel.address = "0x45740ec42b105aa4cf512ee3a5dcef6af5a9f517"
        bstModel.decimals = NativeDecimals.nativeTokenDecimals
        bstModel.iconUrl = ""
        bstModel.isNativeToken = true
        bstModel.name = "BST"
        bstModel.symbol = "BST"
        bstModel.isNativeToken = true
        if let id = TokenModel.identifier(for: bstModel) {
            bstModel.identifier = id
        }
        
        let realm = try! Realm()
        try? realm.write {
            realm.add(bstModel, update: .modified)
            if !wallet.tokenModelList.contains(where: { $0 == bstModel }) {
                wallet.tokenModelList.append(bstModel)
                if !wallet.selectedTokenList.contains(where: { $0 == bstModel }) {
                    wallet.selectedTokenList.append(bstModel)
                }
            }
        }
    }

    func testChain(chainHost: String, wallet: WalletModel) {
        do {
            let metaData = try CITANetwork(url: URL(string: chainHost)).cita.rpc.getMetaData()
            let tokenModel = TokenModel()
            tokenModel.symbol = metaData.tokenSymbol
            if metaData.tokenSymbol == "TDT"{
                tokenModel.iconUrl = "https://oss01.taidihub.com/img/logo_taidi.png"
            }else{
                tokenModel.iconUrl = metaData.tokenAvatar
            }
            tokenModel.name = metaData.tokenName
            tokenModel.isNativeToken = true
            if let tokenIdentifier = TokenModel.identifier(for: tokenModel) {
                tokenModel.identifier = tokenIdentifier
            }

            let chainModel = ChainModel()
            chainModel.chainId = metaData.chainId
            chainModel.chainName = metaData.chainName
            chainModel.httpProvider = chainHost
            chainModel.nativeTokenIdentifier = tokenModel.identifier
            if let chainIdentifier = ChainModel.identifier(for: chainModel) {
                chainModel.identifier = chainIdentifier
            }
            tokenModel.chainIdentifier = chainModel.identifier

            let realm = try Realm()
            try realm.write {
                
                realm.add(tokenModel, update: .modified)
                realm.add(chainModel, update: .modified)
                if !wallet.chainModelList.contains(where: { $0 == chainModel }) {
                    wallet.chainModelList.append(chainModel)
                }
                if !wallet.tokenModelList.contains(where: { $0 == tokenModel }) {
                    wallet.tokenModelList.append(tokenModel)
                    if !wallet.selectedTokenList.contains(where: { $0 == tokenModel }) {
                        wallet.selectedTokenList.append(tokenModel)
                    }
                }
            }
            
            self.addBingShengToken(chainModel: chainModel)
            
        } catch {
        }

    }
    
    func addBingShengToken(chainModel : ChainModel){
        let contractAddress = "0x18e1334b5D70024533419b8bbDaa31518D8Fd783"
        
        let chainId = "0x1"
        let chainName = "taidi-chain"
        let httpProvider = "https://testnet.taidihub.com"
        let chain = Chain(chainId: chainId, chainName: chainName, httpProvider: httpProvider)

        if let tokenModel = AddCITAToken.erc20Token(chain: chain, contractAddress: contractAddress) {
            do {
                let realm = try Realm()
                let wallet = AppModel.current.currentWallet!
                var tokenModel = tokenModel
                if let tokenIdentifier = TokenModel.identifier(for: tokenModel) {
                    tokenModel = realm.object(ofType: TokenModel.self, forPrimaryKey: tokenIdentifier)!
                } else {
                    try realm.write {
                        realm.add(tokenModel, update: .modified)
                    }
                }
                
                if !wallet.tokenModelList.contains(where: { $0 == tokenModel }) {
                    try realm.write {
                        
                        realm.add(chainModel, update: .modified)

                        wallet.tokenModelList.append(tokenModel)
                        wallet.selectedTokenList.append(tokenModel)
                        wallet.chainModelList.append(chainModel)
                        
                    }
                } else {  }
            } catch {  }
        }
    }

}
