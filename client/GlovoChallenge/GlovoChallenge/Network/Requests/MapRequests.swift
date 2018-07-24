//
//  MapRequests.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift

//MARK: Map Requests
enum MapRequests: Request {
  
  case countries
  case cities
  case city(code: City.Code)

  var path: String {
    switch self {
    case .countries:
      return "countries"
    case .cities:
      return "cities"
    case let .city(code):
      return "cities" + "/" + code.rawValue
    }
  }
}

enum NetOperationError: LocalizedError {
  case parsingResponse
  case serverError(msg: String)
  
  var localizedDescription: String {
    switch self {
    case let .serverError(msg):
      return msg
    case .parsingResponse:
      return "Could not parse response"
    }
  }
}

//MARK: Response Handler
struct ResponseHandler<T: Codable> {
  static func process(_ response: (Response)) -> Observable<T> {
    switch response {
    case let .data(data):
      guard let uResponse = try? JSONDecoder().decode(T.self, from: data) else {
        return .error(NetOperationError.parsingResponse)
      }
      return  Observable<T>.just(uResponse)
    default:
      return Observable<T>.error(NetOperationError.parsingResponse)
    }
  }
  
  static func execute(_ request: Request, in dispatcher: Dispatcher) -> Observable<T> {
    return dispatcher
      .execute(request: request)
      .flatMapLatest({ (response) -> Observable<T> in
        return process(response)
      })
  }
}

struct APIService {
  var countriesNetworkOperation: () -> CountriesNetworkOperation
  var citiesNetworkOperation: () -> CitiesNetworkOperation
  var cityNetworkOperation: (City.Code) -> CityNetworkOperation
}

#if DEBUG
extension APIService {
  static let mock = APIService(countriesNetworkOperation: { CountriesNetworkOperation.mock },
                               citiesNetworkOperation: { CitiesNetworkOperation.mock },
                               cityNetworkOperation: { _ in CityNetworkOperation.mock })
}
#endif

//MARK: Network Oerations
struct CountriesNetworkOperation: NetworkOperation {
  typealias Output = Countries
  
  var request: Request {
    return MapRequests.countries
  }
  var response = ResponseHandler<Output>.execute(_:in:)
  
  func execute(in dispatcher: Dispatcher) -> Observable<Output> {
    return self.response(self.request, dispatcher)
  }
}

#if DEBUG
extension CountriesNetworkOperation {
  static let mock = CountriesNetworkOperation { (_, _) -> Observable<Countries> in
    return Observable.just([Country(code: Country.Code.init(rawValue: "ES"), name: "Spain")])
  }
}
#endif

struct CitiesNetworkOperation: NetworkOperation {
  typealias Output = Cities
  
  var request: Request {
    return MapRequests.cities
  }
  var response = ResponseHandler<Output>.execute(_:in:)
  
  func execute(in dispatcher: Dispatcher) -> Observable<Output> {
    return self.response(self.request, dispatcher)
  }
}

#if DEBUG
extension CitiesNetworkOperation {
  static let mock = CitiesNetworkOperation { (_, _) -> Observable<Cities> in
    return Observable.just([City(code: City.Code.init(rawValue: "BCN"), countryCode: Country.Code.init(rawValue: "ES"), name: "Barcelona", workingArea: ["aqs{FithLoj@{h@l^yYfg@rVxGf`@","qnr{FgbiL|SfU","ahn{F_roKxo@oG","shi{F_~|KbAfHgCf^iBvhAmDr^uRd]mBrc@WIvBcd@vR{\\fDq^jB{hAbCu]iAsI","c~o{Fu{bL|@~Ex_@dj@`m@sn@ooAolC_@hN","kcl{Fqa}K`FuE{LeSqAyDmEGwAlC|AdG","{ap{FghcL|Cz@]jLsDiB","oum{Fwb`L`JmIYuHuK`N","cav{FqlrL","wsr{FizgLl`@ap@lL|Jie@jq@","mov{F_|fLpx@~hAfJmMj}@cqAoQo\\wV|b@y\\}j@ea@pV","}k{{FuoiLnM`Vjd@{RnsAgCnp@vv@d_@gYyjB_kCqS|b@~Wre@__A?","stw{F{nsLqyFk_De[vg@_EzKmIvIiN`@uTlc@dc@dcAzSqNpYvBrBjSgBtWwYqJ_BnIzF`DdDhG~@nXmKfNJ~|@ns@zfA`}CgtB","wlp{Fe`hLlJ{NsDmE}Y_Uma@dq@eAtWx_@mq@","mgq{F{lgL_@mAy@yF","ydr{FqvhLrBpB|IwO_DeC","}nt{F{ylLqAcH","scq{FmqiLzB`IeEpGs^g[fDmC|EtEdAyA","kal{Fwk}KpDgC","ez~{F{vkLuOxCaItNHtJlH`DfMO~H~@xCfA","ujl{Fo~}KhL~P~@lCyE|EuD\\{Lk\\tGwH","oxj{FuxrKw\\ft@e`@`h@KMn`@ug@v\\kt@","anm{Fey~KpuAsuAuKy]_`BbvA","err{Fce}Kj[YlG`KlBvMfK`@YhJgHpKdVnhA{GjHk]mX","iak{FaqbLlj@rbGe|@taBwu@zKolBor@tfEkdE","kgv{Fos{KoOnUuL{Z|R{bA|]dj@","q`q{FahiLzBlAvWnShOae@eMGqHyDkWlL","gpl{Fu_~KtNcHe[gg@aMrO","iwo{Fi|bL{Gl[","ygt{FkzcL}QuWjvAyqBfNh`@gjAzrB","_gl{Fcg~KzAqB~BrAVlEmGpBc@d@Ug@q@gD","{ro{FomfLbJsy@hVjBpGmYd]dT`fAfdEwp@za@","{zr{FonbLnPlbA`c@iYtNiKnQk^f_@yqEqUvr@fCxY{FtS_DrDaAaCutAjrB","sn~{Fu|kLM_h@~a@aKrGl~A","mwl{FkzoKio@hGDObo@iG","iun{FuooK~|@uI~_@yg@x\\st@cSiR","}{q{Fi~dL","kzv{F_y}KyO~TsCyEMm[hCaD","eq|{FkvcLvKbk@zOnMiA`GrClIvZjQ|AiGjcBjuAyAtAd@l[lCnFnOmTxEjDiP~y@hLhZnO}Tb|@rcAtq@mE`GePe~IigRyh@p]gDhK`CxJiPjD{GrOWxJ~HdBdYPaAh~@bMzp@zSN","mqx{Fu`lL}]edAp~@sgB~e@qNt|AjgB_\\tj@k|@z{@qXdT","w~o{FkpbLv|@nwAkaAjfB","oyl{F{z}KnOsHe[ad@cOlL","_qs{FkiaLlhButCxCpFzG{CXor@xE?|Qat@uLeIk\\pl@mAho@{rB`sC`K|T","ams{Fg`mK??zK~\\fAhC??gAiC","ojt{FiptKrHrS??sHsS","qjj{FakvKiBta@}IxnAWG~ImmAhByb@","u~o{Fa|bLrApGx_@ji@hm@go@scAiuBiLvvA","}qq{FwjiLaQ_OgFbIlDxFhBcC`KvH","iap{FgfcLlD`@q@iR","u`z{F{o`L}@U_@[k@tAw@pDs@|Ai@oCaDiBqBiB{B{@QObCcL","yjl{Fy|}Kz@q@a@aD[FYa@c@p@IfA","ywo{FedbL{DbA","_ur{FwmyKvXfv@ak@pGvSvn@iIhR}W_\\uSpv@rHrSxc@fJvYv_@{m@vlA}G~L`KtrAzK~\\fAhCxgA{h@tL_Gr[u^pa@w`@pnBqfBzIknAfB{a@ue@{a@kw@nMy`Bor@{IgQ_\\yQcWeB","qns{FawnLraAvhAqVja@|Xlu@{KiCeCj@{F}DrBeE?cLmEsOgJuEgg@gr@eaAptAwVs^lfA}cA","iwl{FizoKoo@fG","_`{{FuwhLxBwBoMkX|BvEn@nAbEGzFeD|]oT`An@fiAaEq^al@fNgQgk@}x@xLmMe\\{h@_kBrfA{K~M","cvk{Fep}KyMkW~@cAqWia@r}@o}@nL`uA","c`l{Fgk}KjAwBn@u@j@m@RSRY\\]`@If@tA\\|AkB~A{ApAm@r@","}}q{Fqi{KnOuHxHeMfAcSfDs@tLj^fGX~@FJu_@f_A_fBlcAn~AcoCjiC","_|q{F{khL^a@","uwu{FqkjLyC?","s{n{FajaL|`@bk@xh@ag@s]as@","_nj{FehuKxEwdAvRa]fDs^rBcjA~B_]yEa]}j@c~BeDtAda@v_F__AhrB","w~o{FaobLrBwDb`AhtAsGxE","{bo{FudiLwUxs@xB`YgFjSaChDq@CmC{Da\\ff@qLlQmTv\\ch@ry@iD|EbM~q@x`Aum@zM{KbRi]","{o}{Fu~fLuS{@cMqo@xAy~@la@joB","qcp{FeqbLeAuEiMbN_D~EoKlOhDtDjV_`@","{xu{FohhLsc@mq@_ZNre@~y@gLlSbQhRb[se@","yre{Fg}gLguB|_JYkArtBi}I","yis{Fc}iL","u}p{FonbLrFpIeNjS_AcAuKdG}AsF","u_q{FylrKjEh@XcEyEm@","{dn{Fg`kLufBqo@}KpStyAlX|LvG","sj{{Fs`iLhKx@jg@oUrmFx{N}KbLmI_Y","igu{FqqcLl@vAv@mAq@mA","krr{FifiL~QoW~@{Ab@_IAwEoGwO}H}FwFcGme@fq@nSK","cxq{FiehL","_lp{Fo{iLzIbDhr@`Dr^pYmZ}gAoWaK","qq{{FibbLmCnMzC~IvZ|P~BcL","man{FkwjLqjBwv@ahEk`FUf@pgEt`FllBhw@","{|o{F_ygL`GdEL|^aH}O","e{x{FgrnL`pAgjByj@cp@edAhqB","m_u{F}biLxVo^qc@EG~C_@tAy@vB","qlq{FyplLtfBpo@saBfr@y\\{{@","ykt{FqddLzp@g}@`GtHzKkZ?qNpYwn@xEyJl\\x`@M|i@ctBvuC","{re{Fy}gLOj@wtGm}A?{@","gnq{FeddLdKsO~_@pk@BdKsAtAOrBaEjD","qrg{FynvK","mws{FidgLdXmb@gDuPoKyNq]eToRjZ","kjt{F{`jLlMOff@eq@sa@}f@`CyC_BmAgdAf{AbMxNdA{H","i`l{Fao}KfDiEfA_BfCpGeCjCsCrA","ubt{FqgjLmGmL","wzp{F}o|K~YmLmArl@}ObA","eii{Fw{|KluBaaJuuG}}A","ijf{FiltK","{`t{Fu{sK??sHsS??","}hp{FupbLpC]nEpAlBsD}AyEeEiA","mqv{FafiL","krq{F}{wK`KsJ}bBi`KmkAwbBhLoM{j@_z@kaAr@","}~o{FgpbLtFdIoGxpDmf@~NsCuFaFmRw\\BmYuaBhv@ki@nKuHlE|F~V}^fDsB","sis{Fm}hLzCzDxChN`GdIxCjElCmDg@e@hDqFvAcBvEqIeB}ArA}BbD{F|@aCP_A{DkBk@k@g@y@qBxC}CcFoF~HwF}H"])])
  }
}
#endif


struct CityNetworkOperation: NetworkOperation {
  typealias Output = City
  
  let code: City.Code
  
  var request: Request {
    return MapRequests.city(code: self.code)
  }
  var response = ResponseHandler<Output>.execute(_:in:)
  
  func execute(in dispatcher: Dispatcher) -> Observable<Output> {
    return self.response(self.request, dispatcher)
  }
}

#if DEBUG
extension CityNetworkOperation {
  static let mock = CityNetworkOperation(code: City.Code.init(rawValue: "BCN")) { (_, _) -> Observable<CityNetworkOperation.Output> in
    return Observable.just(City(code: City.Code.init(rawValue: "BCN"), countryCode: Country.Code.init(rawValue: "ES"), name: "Barcelona", workingArea: ["aqs{FithLoj@{h@l^yYfg@rVxGf`@","qnr{FgbiL|SfU","ahn{F_roKxo@oG","shi{F_~|KbAfHgCf^iBvhAmDr^uRd]mBrc@WIvBcd@vR{\\fDq^jB{hAbCu]iAsI","c~o{Fu{bL|@~Ex_@dj@`m@sn@ooAolC_@hN","kcl{Fqa}K`FuE{LeSqAyDmEGwAlC|AdG","{ap{FghcL|Cz@]jLsDiB","oum{Fwb`L`JmIYuHuK`N","cav{FqlrL","wsr{FizgLl`@ap@lL|Jie@jq@","mov{F_|fLpx@~hAfJmMj}@cqAoQo\\wV|b@y\\}j@ea@pV","}k{{FuoiLnM`Vjd@{RnsAgCnp@vv@d_@gYyjB_kCqS|b@~Wre@__A?","stw{F{nsLqyFk_De[vg@_EzKmIvIiN`@uTlc@dc@dcAzSqNpYvBrBjSgBtWwYqJ_BnIzF`DdDhG~@nXmKfNJ~|@ns@zfA`}CgtB","wlp{Fe`hLlJ{NsDmE}Y_Uma@dq@eAtWx_@mq@","mgq{F{lgL_@mAy@yF","ydr{FqvhLrBpB|IwO_DeC","}nt{F{ylLqAcH","scq{FmqiLzB`IeEpGs^g[fDmC|EtEdAyA","kal{Fwk}KpDgC","ez~{F{vkLuOxCaItNHtJlH`DfMO~H~@xCfA","ujl{Fo~}KhL~P~@lCyE|EuD\\{Lk\\tGwH","oxj{FuxrKw\\ft@e`@`h@KMn`@ug@v\\kt@","anm{Fey~KpuAsuAuKy]_`BbvA","err{Fce}Kj[YlG`KlBvMfK`@YhJgHpKdVnhA{GjHk]mX","iak{FaqbLlj@rbGe|@taBwu@zKolBor@tfEkdE","kgv{Fos{KoOnUuL{Z|R{bA|]dj@","q`q{FahiLzBlAvWnShOae@eMGqHyDkWlL","gpl{Fu_~KtNcHe[gg@aMrO","iwo{Fi|bL{Gl[","ygt{FkzcL}QuWjvAyqBfNh`@gjAzrB","_gl{Fcg~KzAqB~BrAVlEmGpBc@d@Ug@q@gD","{ro{FomfLbJsy@hVjBpGmYd]dT`fAfdEwp@za@","{zr{FonbLnPlbA`c@iYtNiKnQk^f_@yqEqUvr@fCxY{FtS_DrDaAaCutAjrB","sn~{Fu|kLM_h@~a@aKrGl~A","mwl{FkzoKio@hGDObo@iG","iun{FuooK~|@uI~_@yg@x\\st@cSiR","}{q{Fi~dL","kzv{F_y}KyO~TsCyEMm[hCaD","eq|{FkvcLvKbk@zOnMiA`GrClIvZjQ|AiGjcBjuAyAtAd@l[lCnFnOmTxEjDiP~y@hLhZnO}Tb|@rcAtq@mE`GePe~IigRyh@p]gDhK`CxJiPjD{GrOWxJ~HdBdYPaAh~@bMzp@zSN","mqx{Fu`lL}]edAp~@sgB~e@qNt|AjgB_\\tj@k|@z{@qXdT","w~o{FkpbLv|@nwAkaAjfB","oyl{F{z}KnOsHe[ad@cOlL","_qs{FkiaLlhButCxCpFzG{CXor@xE?|Qat@uLeIk\\pl@mAho@{rB`sC`K|T","ams{Fg`mK??zK~\\fAhC??gAiC","ojt{FiptKrHrS??sHsS","qjj{FakvKiBta@}IxnAWG~ImmAhByb@","u~o{Fa|bLrApGx_@ji@hm@go@scAiuBiLvvA","}qq{FwjiLaQ_OgFbIlDxFhBcC`KvH","iap{FgfcLlD`@q@iR","u`z{F{o`L}@U_@[k@tAw@pDs@|Ai@oCaDiBqBiB{B{@QObCcL","yjl{Fy|}Kz@q@a@aD[FYa@c@p@IfA","ywo{FedbL{DbA","_ur{FwmyKvXfv@ak@pGvSvn@iIhR}W_\\uSpv@rHrSxc@fJvYv_@{m@vlA}G~L`KtrAzK~\\fAhCxgA{h@tL_Gr[u^pa@w`@pnBqfBzIknAfB{a@ue@{a@kw@nMy`Bor@{IgQ_\\yQcWeB","qns{FawnLraAvhAqVja@|Xlu@{KiCeCj@{F}DrBeE?cLmEsOgJuEgg@gr@eaAptAwVs^lfA}cA","iwl{FizoKoo@fG","_`{{FuwhLxBwBoMkX|BvEn@nAbEGzFeD|]oT`An@fiAaEq^al@fNgQgk@}x@xLmMe\\{h@_kBrfA{K~M","cvk{Fep}KyMkW~@cAqWia@r}@o}@nL`uA","c`l{Fgk}KjAwBn@u@j@m@RSRY\\]`@If@tA\\|AkB~A{ApAm@r@","}}q{Fqi{KnOuHxHeMfAcSfDs@tLj^fGX~@FJu_@f_A_fBlcAn~AcoCjiC","_|q{F{khL^a@","uwu{FqkjLyC?","s{n{FajaL|`@bk@xh@ag@s]as@","_nj{FehuKxEwdAvRa]fDs^rBcjA~B_]yEa]}j@c~BeDtAda@v_F__AhrB","w~o{FaobLrBwDb`AhtAsGxE","{bo{FudiLwUxs@xB`YgFjSaChDq@CmC{Da\\ff@qLlQmTv\\ch@ry@iD|EbM~q@x`Aum@zM{KbRi]","{o}{Fu~fLuS{@cMqo@xAy~@la@joB","qcp{FeqbLeAuEiMbN_D~EoKlOhDtDjV_`@","{xu{FohhLsc@mq@_ZNre@~y@gLlSbQhRb[se@","yre{Fg}gLguB|_JYkArtBi}I","yis{Fc}iL","u}p{FonbLrFpIeNjS_AcAuKdG}AsF","u_q{FylrKjEh@XcEyEm@","{dn{Fg`kLufBqo@}KpStyAlX|LvG","sj{{Fs`iLhKx@jg@oUrmFx{N}KbLmI_Y","igu{FqqcLl@vAv@mAq@mA","krr{FifiL~QoW~@{Ab@_IAwEoGwO}H}FwFcGme@fq@nSK","cxq{FiehL","_lp{Fo{iLzIbDhr@`Dr^pYmZ}gAoWaK","qq{{FibbLmCnMzC~IvZ|P~BcL","man{FkwjLqjBwv@ahEk`FUf@pgEt`FllBhw@","{|o{F_ygL`GdEL|^aH}O","e{x{FgrnL`pAgjByj@cp@edAhqB","m_u{F}biLxVo^qc@EG~C_@tAy@vB","qlq{FyplLtfBpo@saBfr@y\\{{@","ykt{FqddLzp@g}@`GtHzKkZ?qNpYwn@xEyJl\\x`@M|i@ctBvuC","{re{Fy}gLOj@wtGm}A?{@","gnq{FeddLdKsO~_@pk@BdKsAtAOrBaEjD","qrg{FynvK","mws{FidgLdXmb@gDuPoKyNq]eToRjZ","kjt{F{`jLlMOff@eq@sa@}f@`CyC_BmAgdAf{AbMxNdA{H","i`l{Fao}KfDiEfA_BfCpGeCjCsCrA","ubt{FqgjLmGmL","wzp{F}o|K~YmLmArl@}ObA","eii{Fw{|KluBaaJuuG}}A","ijf{FiltK","{`t{Fu{sK??sHsS??","}hp{FupbLpC]nEpAlBsD}AyEeEiA","mqv{FafiL","krq{F}{wK`KsJ}bBi`KmkAwbBhLoM{j@_z@kaAr@","}~o{FgpbLtFdIoGxpDmf@~NsCuFaFmRw\\BmYuaBhv@ki@nKuHlE|F~V}^fDsB","sis{Fm}hLzCzDxChN`GdIxCjElCmDg@e@hDqFvAcBvEqIeB}ArA}BbD{F|@aCP_A{DkBk@k@g@y@qBxC}CcFoF~HwF}H"]))
  }
}
#endif


