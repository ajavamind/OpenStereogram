/**
 * Class to randomly select a color from a set of three colors. 
 * @author Gustavo
 */
public class ColorGenerator {
	
	//protected Random randomizer; // the randomizer
	protected int[] colors; // the eligible colors
	
	/**
	 * Creates a random color generator for 3 defined colors.
	 * @param color1 One of the eligible colors.
	 * @param color2 One of the eligible colors.
	 * @param color3 One of the eligible colors.
	 */
	public ColorGenerator(int color1, int color2, int color3) {
		this.colors = new int[3];
		this.colors[0] = color1;
		this.colors[1] = color2;
		this.colors[2] = color3;
	}
	
	/**
	 * Default constructor to be called from subclass constructor.
	 */
	protected ColorGenerator() {
		// do nothing
	}
	
	/**
	 * Select randomly one of three colors.
	 * @return A randomly selected color.
	 */
	public int getRandomColor() {
    float r = random(colors.length);
    int i=0;
    if (r>=2) i=2;
    else if (r>=1) i=1;
		return this.colors[ i ];
	}
}