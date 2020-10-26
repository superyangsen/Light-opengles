//
//  TestViewController.swift
//  Light
//
//  Created by 3i_yang on 2020/10/22.
//

import GLKit

let kLimitDegree: Float = 35

class TestViewController: GLKViewController {

    var degreeX:Float = 0
    var degreeY:Float = 0
    private var shader: WYGLBaseShader?
    
    private var bufferModel: WYGLBaseBufferModel?
    
    private var mvpMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var modelMatrix: GLKMatrix4 = GLKMatrix4Identity
    
    private var angleX: Int = 30
    private var angleY: Int = 30
    
    var glView: WYGLView {
        return self.view as! WYGLView
    }
    
    override func loadView() {
        self.view = WYGLView(frame: CGRect(x: 0, y: kNavigationBarAndStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavigationBarAndStatusHeight))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = (touches as NSSet).anyObject() as? UITouch {
            let currentPoint = touch.location(in: self.view)
            let previousPoint = touch.previousLocation(in: self.view)
            self.degreeY += Float(currentPoint.y - previousPoint.y)
            self.degreeX += Float(currentPoint.x - previousPoint.x)
            if self.degreeY > kLimitDegree {
                self.degreeY = kLimitDegree;
            }
            if self.degreeY < -kLimitDegree {
                self.degreeY = -kLimitDegree;
            }
            self.updateMVPMartix(ratio: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shader = WYGLBaseShader()
        glEnable(GLenum(GL_DEPTH_TEST))
        self.bufferModel = WYGLBaseBufferModel(shader: self.shader!, hasIndexBuffer: true)
        self.bufferModel?.loadTextures(filename: "tiger.jpeg")
        self.loadData()
        
        let _ = Timer.scheduledTimer(withTimeInterval: -0.5, repeats: true) { (_) in
            self.angleX += 10
            self.angleY += 10
            self.updateMVPMartix(ratio: 1)
        }
        self.updateMVPMartix(ratio: 1)
    }
    
    let pos: [GLfloat] = [
        // 前
        -0.5, 0.5, 0.5, 0, 0, 1,
        -0.5, -0.5, 0.5, 0, 0, 1,
        0.5, -0.5, 0.5, 0, 0, 1,
        0.5, 0.5, 0.5, 0, 0, 1,
        // 后
        -0.5, 0.5, -0.5, 0, 0, -1,
        -0.5, -0.5, -0.5, 0, 0, -1,
        0.5, -0.5, -0.5, 0, 0, -1,
        0.5, 0.5, -0.5, 0, 0, -1,
        // 左
        -0.5, 0.5, -0.5, -1, 0, 0,
        -0.5, -0.5, -0.5, -1, 0, 0,
        -0.5, -0.5, 0.5, -1, 0, 0,
        -0.5, 0.5, 0.5, -1, 0, 0,
        // 右
        0.5, 0.5, -0.5, 1, 0, 0,
        0.5, -0.5, -0.5, 1, 0, 0,
        0.5, -0.5, 0.5, 1, 0, 0,
        0.5, 0.5, 0.5, 1, 0, 0,
        // 上
        -0.5, 0.5, 0.5, 0, 1, 0,
        0.5, 0.5, 0.5, 0, 1, 0,
        0.5, 0.5, -0.5, 0, 1, 0,
        -0.5, 0.5, -0.5, 0, 1, 0,
        // 下
        -0.5, -0.5, 0.5, 0, -1, 0,
        0.5, -0.5, 0.5, 0, -1, 0,
        0.5, -0.5, -0.5, 0, -1, 0,
        -0.5, -0.5, -0.5, 0, -1, 0,
    ]
    
    let indices: [GLuint] = [
        0, 1, 2,
        2, 3, 0,
        
        4, 5, 6,
        6, 7, 4,
        
        8, 9, 10,
        10, 11, 8,
        
        12, 13, 14,
        14, 15, 12,
        
        16, 17, 18,
        18, 19, 16,
        
        20, 21, 22,
        22, 23, 20
    ]
    
    func loadData() {
        let textures = [GLTexture(u: 0, v: 1), GLTexture(u: 0, v: 0), GLTexture(u: 1, v: 0), GLTexture(u: 1, v: 1)]
        var vertices = [GLVertex]()
        for i in 0..<pos.count / 6 {
            let po = GLPosition(x: pos[i * 6], y: pos[i * 6 + 1], z: pos[i * 6 + 2])
            let normal = GLPosition(x: pos[i * 6 + 3], y: pos[i * 6 + 4], z: pos[i * 6 + 5])
            let color = GLColor(r: 1, g: 0, b: 0, a: 1)
            let ver = GLVertex(position: po, color: color, texture: textures[i % 4], normal: normal)
            vertices.append(ver)
        }
        self.bufferModel?.drawMapData(vertexes: vertices, indices: indices)
    }
    
    func updateMVPMartix(ratio: Float) {
        self.angleX = self.angleX % 360
        self.angleY = self.angleY % 360
        
        let radiansX = Float.pi / 180 * Float(self.degreeX)
        let radiansY = Float.pi / 180 * Float(self.degreeY)
        
        let projectionMartix = GLKMatrix4MakePerspective(45, ratio, 0.1, 100)
        
        let viewMartix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0)
        
        var modelMartix = GLKMatrix4Identity
//        modelMartix = GLKMatrix4Rotate(modelMartix, radiansY, 0, 1, 0)
//        modelMartix = GLKMatrix4Rotate(modelMartix, radiansX, 1, 0, 0)
        modelMartix = GLKMatrix4RotateX(modelMartix, radiansY)
        modelMartix = GLKMatrix4RotateY(modelMartix, radiansX)
        self.mvpMatrix = modelMartix
        self.modelMatrix = modelMartix
        let mvMartix = GLKMatrix4Multiply(viewMartix, modelMartix)
        self.mvpMatrix = GLKMatrix4Multiply(projectionMartix, mvMartix)
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        let scale = UIScreen.main.scale
        let top = (kScreenHeight - kScreenWidth) / 2
        glViewport(0, GLint(top * scale), GLsizei(kScreenWidth * scale), GLsizei((kScreenWidth) * scale))
        
//        self.bufferModel?.render(modelMatrix: self.modelMatrix, projectionMatrix: self.projectionMatrix, viewMatrix: self.viewMatrix)
        self.bufferModel?.render(mvpMatrix: self.mvpMatrix, modelMatrix: self.modelMatrix)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
