//
//  GoogleButton.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI

struct GoogleButton: View {
    
    var onAction: () -> Void
    
    let image: String
    
    var body: some View {
        Button{
            onAction()
        }label:{
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .shadow(radius: 4,x: 0,y: 2)
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .mask(Circle())
            }
            .frame(width: 50,height: 50)
        }
    }
}

