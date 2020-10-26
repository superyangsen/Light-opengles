//
//  WYGLBaseBufferModel.swift
//  OpenglesDemo01
//
//  Created by 3i_yang on 2020/10/19.
//  Copyright © 2020 3irobotix_1. All rights reserved.
//

import GLKit

class WYGLBaseBufferModel: NSObject {
    var shader: WYGLBaseShader?
    var vertexBuffer: GLuint = 0
    var vertexes: [GLVertex] = []
    var indexBuffer: GLuint = 0
    var indices: [GLuint] = []
    var vao: GLuint = 0
    
    var depthBuffer: GLuint = 0
    
    var texture: GLuint = 0
    var textureInfo : GLKTextureInfo?
    
    var hasIndexBuffer: Bool = false
    var glMode: Int32 = 0
    
    init(shader: WYGLBaseShader, hasIndexBuffer: Bool = false, glMode: Int32 = GL_TRIANGLES) {
        self.shader = shader
        self.glMode = glMode
        glGenVertexArraysOES(GLsizei(1), &self.vao)
        glBindVertexArrayOES(self.vao)
        
        glGenBuffers(GLsizei(1), &self.vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER),  MemoryLayout<GLVertex>.size * self.vertexes.count, self.vertexes, GLenum(GL_STATIC_DRAW))
        
        if hasIndexBuffer {
            self.hasIndexBuffer = hasIndexBuffer
            glGenBuffers(GLsizei(1), &self.indexBuffer)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.indexBuffer)
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.size * self.indices.count, self.indices, GLenum(GL_STATIC_DRAW))
        }
        
        glBindVertexArrayOES(0)
        
    }
    
    
    func loadTextures(filename: String) {
        if self.texture != 0 {
            glDeleteTextures(1, &self.texture)
        }
        let path0 = Bundle.main.path(forResource: filename, ofType: nil) ?? ""
        let image0 = UIImage(contentsOfFile: path0)?.cgImage
        let texture0 = try? GLKTextureLoader.texture(with: image0!, options: [GLKTextureLoaderOriginBottomLeft: true, GLKTextureLoaderApplyPremultiplication: true])
        self.textureInfo = texture0
        self.texture = texture0?.name ?? 0
        
        //        self.shader?.texture = self.texture
    }
    
    func drawMapData(vertexes: [GLVertex], indices: [GLuint]? = nil) {
        self.vertexes = vertexes
        
        glBindVertexArrayOES(self.vao)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLVertex>.size * self.vertexes.count, self.vertexes, GLenum(GL_STATIC_DRAW))
        
        if self.hasIndexBuffer && indices != nil && indices!.count > 0 {
//            self.hasIndexBuffer = true
            self.indices = indices!
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.indexBuffer)
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.size * self.indices.count, self.indices, GLenum(GL_STATIC_DRAW))
        }
        
        glVertexAttribPointer(GLuint(WYGLVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLVertex>.size), nil)
        glEnableVertexAttribArray(GLuint(WYGLVertexAttrib.position.rawValue))
        
        
        glVertexAttribPointer(GLuint(WYGLVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLVertex>.size), UnsafePointer(bitPattern: 3 * MemoryLayout<GLfloat>.size))
        glEnableVertexAttribArray(GLuint(WYGLVertexAttrib.color.rawValue))
        
        glVertexAttribPointer(GLuint(WYGLVertexAttrib.texcoord.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLVertex>.size), UnsafePointer(bitPattern: 7 * MemoryLayout<GLfloat>.size))
        glEnableVertexAttribArray(GLuint(WYGLVertexAttrib.texcoord.rawValue))
        
        glVertexAttribPointer(GLuint(WYGLVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLVertex>.size), UnsafePointer(bitPattern: 9 * MemoryLayout<GLfloat>.size))
        glEnableVertexAttribArray(GLuint(WYGLVertexAttrib.normal.rawValue))
        
        glBindVertexArrayOES(0)
    }
    
    //        @objc func render(parentModelViewMatrix: GLKMatrix4 = GLKMatrix4Identity) {
    @objc func render(mvpMatrix: GLKMatrix4 = GLKMatrix4Identity, modelMatrix: GLKMatrix4 = GLKMatrix4Identity) {
        //            self.shader?.modelViewMatrix = GLKMatrix4Multiply(self.shader!.projectionMatrix, parentModelViewMatrix)
        //        self.shader?.texture = self.texture
        //        self.shader?.modelMatrix = GLKMatrix4Multiply(self.shader!.modelMatrix, modelMatrix)
        self.shader?.mvpMatrix = mvpMatrix
        self.shader?.modelMatrix = modelMatrix
        self.shader?.texture = self.texture
        
        self.shader?.prepareToDraw()
        
        glBindVertexArrayOES(self.vao)
        if self.hasIndexBuffer {
            glDrawElements(GLenum(self.glMode), GLsizei(self.indices.count), GLenum(GL_UNSIGNED_INT), nil)
        } else {
            glDrawArrays(GLenum(self.glMode), 0, GLsizei(self.vertexes.count))
        }
        glBindVertexArrayOES(0)
        glUseProgram(0)
    }
    
    @objc func clear() {
        if self.vao != 0 {
            glDeleteVertexArraysOES(1, &self.vao)
            glDeleteBuffers(1, &self.vao)
        }
        if self.vertexBuffer != 0 {
            glDeleteBuffers(1, &self.vertexBuffer)
        }
        if self.indexBuffer != 0 {
            glDeleteBuffers(1, &self.indexBuffer)
        }
    }
    
    deinit {
        self.clear()
    }
}
