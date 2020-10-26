//
//  WYGLBaseShader.swift
//  OpenglesDemo01
//
//  Created by 3i_yang on 2020/10/19.
//  Copyright © 2020 3irobotix_1. All rights reserved.
//

import GLKit

class WYGLBaseShader: NSObject {
    private var program: GLuint = 0
    private var mvpUniform: Int32 = 0
    private var modelUniform: Int32 = 0
    private var lightPosUniform: Int32 =  0
    private var lightColorUnifrom: Int32 = 0
    private var viewPosUniform: Int32 = 0
    private var textureUniform: Int32 = 0
    
    var mvpMatrix: GLKMatrix4 = GLKMatrix4Identity
    var modelMatrix: GLKMatrix4 = GLKMatrix4Identity
    var lightPos: vector_float3 = [1.2, 1, 2]
    var lightColor: vector_float3 = [1, 1, 1]
    var viewPos: vector_float3 = [0, 0, 3]
    var texture: GLuint = 0
    
    override init() {
        super.init()
        
        self.loadShader()
        self.prepareToDraw()
    }
    
    func loadTexture(fileName: String) {
        if self.texture != 0 {
            glDeleteTextures(1, &self.texture)
        }
        let path0 = Bundle.main.path(forResource: fileName, ofType: nil) ?? ""
        let image0 = UIImage(contentsOfFile: path0)?.cgImage
        let texture0 = try? GLKTextureLoader.texture(with: image0!, options: [GLKTextureLoaderOriginBottomLeft: true, GLKTextureLoaderApplyPremultiplication: true])
        self.texture = texture0?.name ?? 0
    }
    
    private func loadShader() {
        self.program = WYGLUtils.loanProgram(verShaderFileName: "shader.vsh", fragShaderFileName: "shader.fsh", bindAttribs: ["a_position": GLuint(WYGLVertexAttrib.position.rawValue), "a_texCoord": GLuint(WYGLVertexAttrib.texcoord.rawValue), "a_normal": GLuint(WYGLVertexAttrib.normal.rawValue)])
        
        self.mvpUniform = Int32(glGetUniformLocation(self.program, "u_mvpMatrix"))
        self.modelUniform = Int32(glGetUniformLocation(self.program, "u_modelMatrix"))
        self.lightPosUniform = Int32(glGetUniformLocation(self.program, "u_lightPos"))
        self.lightColorUnifrom = Int32(glGetUniformLocation(self.program, "u_lightColor"))
        self.viewPosUniform = Int32(glGetUniformLocation(self.program, "u_viewPos"))
        self.textureUniform =  Int32(glGetUniformLocation(self.program, "u_texture"))
        
        print("program: \(self.program), mvpMatrixUniform:\(self.mvpUniform), lightPosUniform:\(self.lightPosUniform), lightColorUnifrom:\(self.lightColorUnifrom), viewPosUniform:\(self.viewPosUniform), textureUniform:\(self.textureUniform)")
    }
    
    func prepareToDraw() {
        glUseProgram(self.program)
        withUnsafePointer(to: &self.mvpMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(self.mvpUniform, 1, 0, $0)
            })
        })
        
        withUnsafePointer(to: &self.modelMatrix, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(self.modelUniform, 1, 0, $0)
            })
        })
        
        glUniform3f(self.lightPosUniform, self.lightPos.x, self.lightPos.y, self.lightPos.z)
        glUniform3f(self.lightColorUnifrom, self.lightColor.x, self.lightColor.y, self.lightColor.z)
        glUniform3f(self.viewPosUniform, self.viewPos.x, self.viewPos.y, self.viewPos.z)
       
        if self.texture != 0 {
            glActiveTexture(GLenum(GL_TEXTURE0))
            glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
            glUniform1f(self.textureUniform, 0)
        }
        
    }
}
