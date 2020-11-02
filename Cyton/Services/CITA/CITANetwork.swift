//
//  CITANetwork.swift
//  Cyton
//
//  Created by XiaoLu on 2018/7/31.
//  Copyright © 2018年 cryptape. All rights reserved.
//

import Foundation
import CITA
import Alamofire

struct CITANetwork {
    static let defaultNode = "https://testnet.taidihub.com"

    func host() -> URL {
        return URL(string: "https://scan.taidihub.com:8888")!
    }

    let cita: CITA

    init(url: URLConvertible? = defaultNode) {
        let provider: HTTPProvider
        if let urlstring = url, let url = try? urlstring.asURL() {
            provider = HTTPProvider(url)!
        } else {
            provider = HTTPProvider(try! CITANetwork.defaultNode.asURL())!
        }
        cita = CITA(provider: provider)
    }
}
