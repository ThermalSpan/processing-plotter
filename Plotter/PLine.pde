public class PLine {
	ArrayList<Point> pointList;
	
	public PLine() {
		pointList = new ArrayList<Point>();
	}
	
	public void add(Point p) {
		pointList.add(p);
	}
	
	public Point get(int i) {
		return pointList.get(i);
	}
	
	public int size() {
		return pointList.size();
	}
}