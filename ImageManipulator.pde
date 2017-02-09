import java.awt.Font;
//import java.awt.Graphics;
//import processing.core.PImage;
//import processing.core.PConstants;
//import processing.core.PApplet;

/**
 * Utility class to manipulate images. The main
 * functions of this class are image resizing and text
 * manipulation inside images.
 * @author Gustavo
 */
public class ImageManipulator {

  /**
   	 * Resizes a given depth map. The resizing is made without
   	 * distortion of original map regardless of the new dimensions given.
   	 * The map will be resized until it touches the
   	 * box measuring {@code width}x{@code height} from inside.
   	 * @param original The original depth map.
   	 * @param width The new map width.
   	 * @param height The new map height.
   	 * @return A resized depth map measuring {@code width}x{@code height}.
   	 */
  public PImage resizeDepthMap( PImage original, int width, int height ) {
    // create image with new map size
    PImage newMap = createImage( width, height, RGB );
    // completely fill the image with black
    newMap.loadPixels();
    for (int i = 0; i < newMap.pixels.length; i++) {
      newMap.pixels[i] = color(0, 0, 0);
    }
    newMap.updatePixels();

    // calculate the new height based on the new width 
    int newHeight = (original.height * width) / original.width;
    // if the resized depth map is going to be placed inside a higher box  
    if ( newHeight <= height ) {
      // center the map along y axis
      int centeredY = (height - newHeight) / 2;
      newMap.copy( original, 0, 0, original.width, original.height, 0, centeredY, width, newHeight);
    }
    // if the resized depth map is going to be placed inside a wider box
    else {
      // calculate the new width based on the new height
      int newWidth = (original.width * height) / original.height;
      // at this point this is always the case
      if ( newWidth <= width ) {
        // center the map along x axis
        int centeredX = (width - newWidth) / 2;
        newMap.copy( original, 0, 0, original.width, original.height, centeredX, 0, newWidth, height);
      }
      // should never get here
      else {
        newMap.copy( original, 0, 0, original.width, original.height, 0, 0, width, height );
      }
    }
    return newMap;
  }

  public PImage resizeTexturePattern(PImage original, int maxSeparation) {
    if ( original.width < maxSeparation ) {
      int newHeight = (original.height * maxSeparation) / original.width;
      PImage resized = createImage( maxSeparation, newHeight, RGB );
      resized.copy( original, 0, 0, original.width, original.height, 0, 0, resized.width, resized.height);
      return resized;
    } else {
      return original;
    }
  }

  public PImage generateTextDepthMap(String texts, int fontSize, int width, int height ) {
    PImage depthMap = createImage( width, height, RGB );
    depthMap.loadPixels();
    for (int i = 0; i < depthMap.pixels.length; i++) {
      depthMap.pixels[i] = color(0, 0, 0);
    }
    depthMap.updatePixels();

// TODO this is incomplete
    //Font f = g.getFont().deriveFont( Font.BOLD, fontSize );
    PFont f;
    
    int textWidth = 300;  //(int)g.getFontMetrics().getStringBounds( text, g ).getWidth();
    int textHeight = 28;   // f.ascent();  //g.getFontMetrics().getAscent();
  
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    g.textSize(fontSize);
    g.fill(color(127,127,127));
    g.text(texts,  (width - textWidth) / 2, 
       ((height - textHeight) / 2) + textHeight );
    g.endDraw();
    
    return g;
  }
}