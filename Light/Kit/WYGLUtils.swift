//
//  WYGLUtils.swift
//  OpenglesDemo01
//
//  Created by 3i_yang on 2020/10/19.
//  Copyright © 2020 3irobotix_1. All rights reserved.
//

import GLKit
import Foundation

struct WYGLUtils {
    static func loadShaderFile(type: GLenum, fileName: String) -> GLuint {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            return 0
        }
        
        do {
            let shaderString = try String(contentsOfFile: path, encoding: .utf8)
            return self.loadShaderString(type: type, shaderString: shaderString)
        } catch {
            return 0
        }
    }
    
    static func loadShaderString(type: GLenum, shaderString: String) -> GLuint {
        let shaderHandle = glCreateShader(type)
        
        var shaderStringLength: GLint = GLint(Int32(shaderString.count))
        var shaderCString = NSString(string: shaderString).utf8String
        
        glShaderSource(shaderHandle, GLsizei(1), &shaderCString, &shaderStringLength)
        
        glCompileShader(shaderHandle)
        
        var compileStatus: GLint = 0
        
        glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
        
        if compileStatus == GL_FALSE {
            var infoLength: GLsizei = 0
            let bufferLength: GLsizei = 1024
            glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            var info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actuallLength: GLsizei = 0
            glGetShaderInfoLog(shaderHandle, bufferLength, &actuallLength, &info)
            let text = String.init(cString: info)
            print("\(GLenum(GL_FRAGMENT_SHADER) == type ? "fragment" : "vertex") error load shader: \(text)")
            return 0
        }
        
        return shaderHandle
    }
    
    static func loanProgram(verShaderFileName: String, fragShaderFileName: String, bindAttribs: [String: GLuint]) -> GLuint {
        let vertexShader = self.loadShaderFile(type: GLenum(GL_VERTEX_SHADER), fileName: verShaderFileName)
        
        if vertexShader == 0 {
            return 0
        }
        
        let fragmentShader = self.loadShaderFile(type: GLenum(GL_FRAGMENT_SHADER), fileName: fragShaderFileName)
        if fragmentShader == 0 {
            glDeleteShader(vertexShader)
            return 0
        }
        
        let programHandle = glCreateProgram()
        if programHandle == 0 {
            return 0
        }
        
        glAttachShader(programHandle, vertexShader)
        glAttachShader(programHandle, fragmentShader)
        
        // 指定属性变量名和通用属性索引之间的关联。在调用glLinkProgram之前，属性绑定不会生效。 成功链接程序对象后，属性变量的索引值将保持固定，直到发生下一个链接命令。
        // glGetAttribLocation返回上次为指定程序对象调用glLinkProgram时实际生效的绑定。 glGetAttribLocation不返回自上次链接操作以来指定的属性绑定。
        for (key, value) in bindAttribs {
            glBindAttribLocation(programHandle, value, key)
        }
        
        glLinkProgram(programHandle)
        
        var linkStatus: GLint = 0
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            var infoLength: GLsizei = 0
            let bufferLength: GLsizei = 1024
            glGetProgramiv(programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            var info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength: GLsizei = 0
            
            glGetProgramInfoLog(programHandle, bufferLength, &actualLength, &info)
            let text = String.init(cString: info)
            print("error load shader: \(text)")
            return 0
        }
        
        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)
        
        return programHandle
    }
}


