#import "GPUImageHazeFilter.h"

NSString *const kGPUImageHazeFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform lowp float distance;
 uniform highp float slope;
 
 void main()
 {
	//todo reconsider precision modifiers	 
	 highp vec4 color = vec4(1.0);//todo reimplement as a parameter
	 
	 highp float  d = textureCoordinate.y * slope  +  distance; 
	 
	 highp vec4 c = texture2D(inputImageTexture, textureCoordinate) ; // consider using unpremultiply
	 
	 
	 c = (c - d * color) / (1.0 -d); 
	 
	 gl_FragColor = c; //consider using premultiply(c);
	 

 }
);





@implementation GPUImageHazeFilter

@synthesize distance = _distance;
@synthesize slope = _slope;
#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageHazeFragmentShaderString]))
    {
		return nil;
    }
    
    distanceUniform = [filterProgram uniformIndex:@"distance"];
	slopeUniform = [filterProgram uniformIndex:@"slope"];
	
    self.distance = 0.2;
    self.slope = 0.0;
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setDistance:(CGFloat)newValue;
{
    _distance = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(distanceUniform, _distance);
}

- (void)setSlope:(CGFloat)newValue;
{
    _slope = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(slopeUniform, _slope);
}

@end
