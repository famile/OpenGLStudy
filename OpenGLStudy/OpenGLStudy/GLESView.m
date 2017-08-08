//
//  GLESView.m
//  OpenGLStudy
//
//  Created by 李涛 on 2017/8/4.
//  Copyright © 2017年 Tao_Lee. All rights reserved.
//

#import "GLESView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLESView (){
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
}

- (void)setupLayer;

@end

@implementation GLESView


+ (Class)layerClass{
    
    //只有【CAEAGLLayer class】类型的layer才支持在其上描绘OpenGL内容
    return [CAEAGLLayer class];
}


- (void)setupLayer{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    
    //CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
    
}

- (void)setupContext{
    //指定OpenGL渲染API版本
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES2.0 context");
        exit(1);
    }
    
    //设置当前上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

/**
 创建renderbuffer
 */
- (void)setupRenderBuffer{
    
    /*
     原型
     void glGenRenderbuffers (GLsizei n, GLuint* renderbuffers)
     为renderbuffer申请一个id，参数n表示申请生成renderbuffer的个数，而renderbuffers返回分配给renderbuffer的id（返回的id不会为0，id 0是OpenGL ES保留的，我们也不能使用id为0的renderbuffer）
     */
    glGenRenderbuffers(1, &_colorRenderBuffer);
    
    /*
     void glBindRenderbuffer (GLenum target, GLuint renderbuffer) 
     这个函数将指定id的renderbuffer设置为当前renderbuffer。参数target必须为GL_RENDERBUFFER，参数renderbuffer就是之前生成的id，会初始化该renderbuffer对象
     */
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}


- (void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    //设置当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    /*
     void glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)
     
     attach到framebuffer上（如果renderbuffer不为0）或从framebuffer上detach分离（如果renderbuffer为0）。参数attachment是指定renderbuffer被装配到那个装配点上，其值是GL_COLOR_ATTACHMENT0，GL_DEPTH_ATTACHMENT,GL_STENCIL_ATTACHMENT中的一个，分别对应color，depth和stencil三大buffer
     */
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
}


- (void)destoryRenderAndFrameBuffer{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

- (void)render{
    /*
     glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampfalpha) 
     用来设置清屏颜色，默认为黑色
     */
    glClearColor(0, 1.0, 0, 1.0);
    
    /*
     glClear (GLbitfieldmask)
     用来指定要用清屏颜色清除由mask指定的buffer，mask 可以是 GL_COLOR_BUFFER_BIT，GL_DEPTH_BUFFER_BIT和GL_STENCIL_BUFFER_BIT的自由组合，这里只使用到colorbuffer，所以清除的就是colorbuffer
     */
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)layoutSubviews{
    
    [self setupLayer];
    [self setupContext];
    
    [self destoryRenderAndFrameBuffer];
    
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    
    [self render];
    
}






@end
