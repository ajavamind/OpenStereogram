public class StereogramGenerator {

	public PImage generateSIRD( PImage depthMap,
			color color1, color color2, color color3, float color1Intensity,
			int width, int height,
			float observationDistanceInches, float eyeSeparationInches,
			float maxDepthInches, float minDepthInches,
			int horizontalPPI ) {
		
		depthMap = imageManipulator.resizeDepthMap(depthMap, width, height);
		ColorGenerator colors; 
		if ( color3 == 0 ) {
      //colors = new UnbalancedColorGenerator( color1.getRGB(), color2.getRGB(), color1Intensity );
      colors = new UnbalancedColorGenerator( color1, color2, color1Intensity );
		}
		else {
      //colors = new ColorGenerator( color1.getRGB(), color2.getRGB(), color3.getRGB() );
      colors = new ColorGenerator( color1, color2, color3 );
		}
		
		PImage stereogram = new PImage(width, height, RGB);
		int[] linksL = new int[width];
		int[] linksR = new int[width];
		int observationDistance = convertoToPixels(observationDistanceInches, horizontalPPI);
		int eyeSeparation = convertoToPixels(eyeSeparationInches, horizontalPPI);
		int maxdepth = getMaxDepth( convertoToPixels(maxDepthInches, horizontalPPI), observationDistance );
		int minDepth = getMinDepth( 0.55f, maxdepth, observationDistance, convertoToPixels(minDepthInches, horizontalPPI) );

		for ( int l = 0; l < height; l++ ) {
			for ( int c = 0; c < width; c++ ) {
				linksL[c] = c;
				linksR[c] = c;
			}
			
			for ( int c = 0; c < width; c++ ) {
				int depth = obtainDepth( depthMap.get(c, l), maxdepth, minDepth );
				int separation = getSeparation( observationDistance, eyeSeparation, depth );
				int left = c - (separation / 2);
				int right = left + separation;
				
				if ( left >= 0 && right < width ) {
					boolean visible = true;
					
					if ( linksL[right] != right) {
						if ( linksL[right] < left) {
							linksR[linksL[right]] = linksL[right];
							linksL[right] = right;
						}
						else {
							visible = false;
						}
					}
					if ( linksR[left] != left) {
						if ( linksR[left] > right) {
							linksL[linksR[left]] = linksR[left];
							linksR[left] = left;
						}
						else {
							visible = false;
						}
					}
					
					if ( visible ) {
						linksL[right] = left;
						linksR[left] = right;
					}					
				}
			}
			
			for ( int c = 0; c < width; c++ ) {
				if ( linksL[c] == c ) {
					stereogram.set( c, l, colors.getRandomColor() );
				}
				else {
					stereogram.set( c, l, stereogram.get(linksL[c], l) );
				}
			}
		}
		
		return stereogram;
	}

	private int getMinDepth(float separationFactor, int maxdepth, int observationDistance, int suppliedMinDepth) {
		int computedMinDepth = (int)( (separationFactor * maxdepth * observationDistance) /
			(((1 - separationFactor) * maxdepth) + observationDistance) );
		
		return Math.min( Math.max( computedMinDepth, suppliedMinDepth), maxdepth);
	}

	private int getMaxDepth(int suppliedMaxDepth, int observationDistance) {
		return Math.max( Math.min( suppliedMaxDepth, observationDistance), 0);
	}
	
	private int convertoToPixels(float valueInches, int ppi) {
		return (int)(valueInches * ppi);
	}

	private int obtainDepth(int depth, int maxDepth, int minDepth) {
    //return maxDepth - ((color( depth )).red * (maxDepth - minDepth) / 255);
    return maxDepth - ((int)brightness(depth) * (maxDepth - minDepth) / 255);
	}
	
	private int getSeparation(int observationDistance, int eyeSeparation, int depth) {
		return (eyeSeparation * depth) / (depth + observationDistance);
	}

	public PImage generateTexturedSIRD( PImage depthMap, PImage texturePattern,
			int width, int height,
			float observationDistanceInches, float eyeSeparationInches,
			float maxDepthInches, float minDepthInches,
			int horizontalPPI, int verticalPPI ) {
		
		depthMap = imageManipulator.resizeDepthMap(depthMap, width, height);		
		PImage stereogram = new PImage(width, height, RGB);
		int[] linksL = new int[width];
		int[] linksR = new int[width];
		int observationDistance = convertoToPixels(observationDistanceInches, horizontalPPI);
		int eyeSeparation = convertoToPixels(eyeSeparationInches, horizontalPPI);
		int maxDepth = getMaxDepth( convertoToPixels(maxDepthInches, horizontalPPI), observationDistance );
		int minDepth = getMinDepth( 0.55f, maxDepth, observationDistance, convertoToPixels(minDepthInches, horizontalPPI) );
		int verticalShift = verticalPPI / 16;
		int maxSeparation = getSeparation(observationDistance, eyeSeparation, maxDepth);
    //println("texturePattern w="+texturePattern.width + " h="+texturePattern.height);
		texturePattern = imageManipulator.resizeTexturePattern( texturePattern, maxSeparation );
    //println("maxSeparation="+maxSeparation);
    //println("resized texturePattern w="+texturePattern.width + " h="+texturePattern.height);
		for ( int l = 0; l < height; l++ ) {
			for ( int c = 0; c < width; c++ ) {
				linksL[c] = c;
				linksR[c] = c;
			}
			
			for ( int c = 0; c < width; c++ ) {
				int depth = obtainDepth( depthMap.get(c, l), maxDepth, minDepth );
				int separation = getSeparation(observationDistance, eyeSeparation, depth);
				int left = c - (separation / 2);
				int right = left + separation;
				
				if ( left >= 0 && right < width ) {
					boolean visible = true;
					
					if ( linksL[right] != right) {
						if ( linksL[right] < left) {
							linksR[linksL[right]] = linksL[right];
							linksL[right] = right;
						}
						else {
							visible = false;
						}
					}
					if ( linksR[left] != left) {
						if ( linksR[left] > right) {
							linksL[linksR[left]] = linksR[left];
							linksR[left] = left;
						}
						else {
							visible = false;
						}
					}
					
					if ( visible ) {
						linksL[right] = left;
						linksR[left] = right;
					}					
				}
			}
			
			int lastLinked = -10;
			for (int c = 0; c < width; c++) {
				if ( linksL[c] == c ) {
					if (lastLinked == c - 1) {
						stereogram.set( c, l, stereogram.get(c - 1, l) );
					}
					else {
						stereogram.set(c, l, texturePattern.get(
								c % maxSeparation,
								(l + ((c / maxSeparation) * verticalShift)) % texturePattern.height ));
					}
				}
				else {
					stereogram.set( c, l, stereogram.get(linksL[c], l) );
					lastLinked = c;
				}
			}
		}
		
		return stereogram;
	}
}