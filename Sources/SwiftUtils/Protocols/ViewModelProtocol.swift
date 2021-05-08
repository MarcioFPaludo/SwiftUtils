//
//  ViewModelProtocol.swift
//  
//
//  Created by Marcio F. Paludo on 29/01/21.
//

import ExceptionCatcher
import UIKit

fileprivate extension UIStoryboard {
    private static let available = Bundle.main.urls(forResourcesWithExtension: "storyboardc", subdirectory: nil)?.map({
        return UIStoryboard(name: $0.lastPathComponent.replacingOccurrences(of: ".storyboardc", with: ""), bundle: nil)
    })
    
    static func findStoryboard<VC: UIViewController>(for vc: VC.Type? = nil) -> UIStoryboard? {
        return available?.first(where: { return $0.instantiateVC(VC.self) != nil })
    }
    
    func instantiateVC<VC: UIViewController>(_ vc: VC.Type? = nil) -> VC? {
        return (try? ExceptionCatcher.catch(callback: { () -> UIViewController in
            if let identifier = (vc as? IdentifiableProtocol.Type)?.identifier {
                return instantiateViewController(withIdentifier: identifier)
            } else {
                return instantiateViewController(withIdentifier: String(describing: VC.self))
            }
        })) as? VC
    }
}

// MARK: - ViewModelProtocol


public protocol ViewModelProtocol {
    
    typealias ConfigureHandler<T> = (T) -> Void
    
    /**
     
     
     */
    func updateItens()
    
    /**
     
     
     */
    func add(_ view: UIView)
  
    /**
     
     
     */
    func remove(_ view: UIView)
    
    /**
     
     
     */
    func configure(_ view: UIView)
    
    /**
     Create an instance of ViewController initialized with the data from an `Storyboard` or calling the default initializer.
    
     - parameter VCType: The ViewController type
     
     - returns An instance of the ViewController of VCType
     
     - warning This method need that the value of the identifier of the `ViewController` matches with the identifier string provided by the `IdentifiableProtocol`
     */
    func viewController<VC: UIViewController>(_ vc: VC.Type?) -> VC
    func bottomSheetController<VC: UIViewController>(_ vc: VC.Type, configure handler: ConfigureHandler<VC>?) -> BottomSheetController
    func navigationController<VC: UIViewController>(_ vc: VC.Type, configure handler: ConfigureHandler<VC>?) -> UINavigationController
}

fileprivate struct WeakItem: Equatable {
    fileprivate static var itens: [String: [WeakItem]] = [:]
    weak var view: UIView?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.view == rhs.view
    }
    
    static func == (lhs: Self, rhs: UIView) -> Bool {
        return lhs.view == rhs
    }
}

extension ViewModelProtocol {
    fileprivate var key: String { return "\(unsafeBitCast(self, to: Int.self))" }
    
    public func add(_ view: UIView) {
        var itens = WeakItem.itens[key] ?? []
        
        if itens.first(where: { $0 == view }) == nil {
            itens.append(WeakItem(view: view))
            WeakItem.itens[key] = itens
            configure(view)
        }
    }
    
    public func remove(_ view: UIView) {
        if var itens = WeakItem.itens[key], let index = itens.firstIndex(where: { $0 == view }) {
            itens.remove(at: index)
            WeakItem.itens[key] = itens
        }
    }
    
    public func updateItens() {
        WeakItem.itens[key]?.forEach({
            if let v = $0.view {
                configure(v)
            }
        })
    }
    
    public func viewController<VC: UIViewController>(_ vc: VC.Type? = nil) -> VC {
        return UIStoryboard.findStoryboard(for: VC.self)?.instantiateVC(vc) ?? VC()
    }
    
    public func bottomSheetController<VC: UIViewController>(_ vc: VC.Type, configure handler: ConfigureHandler<VC>? = nil) -> BottomSheetController {
        let newVC = viewController(vc), nc = BottomSheetController(withContent: newVC);
        handler?(newVC)
        return nc
    }
    
    public func navigationController<VC: UIViewController>(_ vc: VC.Type, configure handler: ConfigureHandler<VC>? = nil) -> UINavigationController {
        let newVC = viewController(vc), nc = UINavigationController(rootViewController: newVC);
        handler?(newVC)
        return nc
    }
}
