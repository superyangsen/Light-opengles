//
//  WYGLModel.swift
//  OpenglesDemo01
//
//  Created by 3i_yang on 2020/10/19.
//  Copyright © 2020 3irobotix_1. All rights reserved.
//

import UIKit

func kIsIphoneX() -> Bool {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
    return false
}
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
let kScreenScale: CGFloat = UIScreen.main.scale
let kNavigationBarAndStatusHeight: CGFloat = kIsIphoneX() ? 88 : 64

let kGLPositionScale = 1

enum WYGLVertexAttrib: Int {
    case position = 0
    case color = 1
    case texcoord = 2
    case normal = 3
}

enum UniformAttrib {
    case modelProjectionMatrix
    case texture0Sampler2D
}

extension UIColor {
    func red() -> CGFloat {
        let red = self.cgColor.components?[0] ?? 0
        return red
    }
    
    func green() -> CGFloat {
        let green = self.cgColor.components?[1] ?? 0
        return green
    }
    
    func blue() -> CGFloat {
        let blue = self.cgColor.components?[2] ?? 0
        return blue
    }
    
    func alpha() -> CGFloat {
        let alpha = self.cgColor.components?[3] ?? 0
        return alpha
    }
}

struct GLPosition {
    var x: GLfloat = 0
    var y: GLfloat = 0
    var z: GLfloat = 0
    
    
}

struct GLColor {
    var r: GLfloat = 1
    var g: GLfloat = 1
    var b: GLfloat = 1
    var a: GLfloat = 0
    
    static func uicolorToGLColor(uicolor: UIColor) -> GLColor {
        return GLColor(r: GLfloat(uicolor.red()), g: GLfloat(uicolor.green()), b: GLfloat(uicolor.blue()), a: GLfloat(uicolor.alpha()))
    }
}

struct GLTexture {
    var u: GLfloat = 0
    var v: GLfloat = 0
}

struct GLVertex {
    var position: GLPosition = GLPosition()
    var color: GLColor = GLColor()
    var texture: GLTexture = GLTexture()
    var normal: GLPosition = GLPosition()
    
    static let zero: GLVertex = GLVertex(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    static let dist: GLVertex = GLVertex(10000.0, 10000.0, 10000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    
    static func zero(_ number: Int) -> [GLVertex] {
        var vertexs = [GLVertex]()
        for _ in 0..<number {
            vertexs.append(zero)
        }
        return vertexs
    }
    
    static func dist(_ number : Int) -> [GLVertex] {
        var vertexs = [GLVertex]()
        for _ in 0..<number {
            vertexs.append(dist)
        }
        return vertexs
    }
    
    init(position: GLPosition, color: GLColor, texture: GLTexture? = nil, normal: GLPosition = GLPosition()) {
        self.position = position
        self.color = color
        self.normal = normal
        if texture != nil {
            self.texture = texture!
        }
    }

    init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ r : GLfloat = 0.0, _ g : GLfloat = 0.0, _ b : GLfloat = 0.0, _ a : GLfloat = 1.0,_ u:GLfloat = 0.0,_ v:GLfloat = 0.0) {
        self.position.x = x * GLfloat(kGLPositionScale)
        self.position.y = y * GLfloat(kGLPositionScale)
        self.position.z = z
        
        self.color.r = r
        self.color.g = g
        self.color.b = b
        self.color.a = a
        self.texture.u = u
        self.texture.v = v
    }
    
    
}
