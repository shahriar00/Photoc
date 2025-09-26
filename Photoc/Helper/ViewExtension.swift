//
//  ViewExtension.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import Foundation
import SwiftUI

extension View {
    func getViewController () -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
}
