//
//  WYGLView.swift
//  OpenglesDemo01
//
//  Created by 3i_yang on 2020/10/19.
//  Copyright © 2020 3irobotix_1. All rights reserved.
//

import UIKit
import GLKit

class WYGLView: GLKView {

    override init(frame: CGRect) {
            super.init(frame: frame)
            
//            self.layer.isOpaque = true
//            self.context = EAGLContext(api: .openGLES3)!
//            self.drawableColorFormat = .RGB565
            
            self.layer.isOpaque = true
            self.context = EAGLContext(api: .openGLES3)!
            self.drawableColorFormat = .RGB565
            self.drawableMultisample = .multisample4X
        self.drawableDepthFormat = .format16
            
            EAGLContext.setCurrent(self.context)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
